import SwiftUI // <--- Crucial for Haptics & Animations
import AVFoundation
import Combine
import SwiftData
// ... rest of the class

@MainActor
class AudioRecorderViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    static let shared = AudioRecorderViewModel()
    
    @Published var isRecording = false
    @Published var recordingTime: TimeInterval = 0
    @Published var isPlaying = false
    @Published var currentPlayingID: String?
    @Published var hasJustFinished = false // <--- Added back for HomeView support
    
    // Audio Visualization
    @Published var audioLevels: [CGFloat] = Array(repeating: 0.1, count: 20)
    
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var modelContext: ModelContext?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    // Legacy support for HomeView
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            // Fixed deprecated 'allowBluetooth'
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetoothA2DP, .allowAirPlay])
            try session.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording() {
        let fileName = "evidence_\(Date().timeIntervalSince1970).m4a"
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: path, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.isMeteringEnabled = true
            audioRecorder?.record()
            
            withAnimation { isRecording = true }
            startTimer()
            
            // Haptic Feedback
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
            
        } catch {
            print("Could not start recording: \(error)")
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        withAnimation { isRecording = false }
        stopTimer()
        
        // Signal that recording finished so HomeView can show alert
        self.hasJustFinished = true
        
        // Save to SwiftData if context is available
        if let context = modelContext, let url = audioRecorder?.url {
            let newRecording = Recording(filename: url.lastPathComponent, timestamp: Date(), duration: recordingTime)
            context.insert(newRecording)
            try? context.save()
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    // ... (Playback logic remains the same)
    func playRecording(_ recording: Recording) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recording.filename)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            currentPlayingID = recording.id
        } catch { print("Playback failed") }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
        currentPlayingID = nil
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        currentPlayingID = nil
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            Task { @MainActor in
                if self.isRecording {
                    self.recordingTime += 0.05
                    self.audioRecorder?.updateMeters()
                    let power = self.audioRecorder?.averagePower(forChannel: 0) ?? -160
                    let level = self.normalizeSoundLevel(level: power)
                    
                    // Shift array for visualizer
                    if self.audioLevels.count >= 20 { self.audioLevels.removeFirst() }
                    self.audioLevels.append(CGFloat(level))
                }
            }
        }
    }
    
    private func normalizeSoundLevel(level: Float) -> Float {
        let level = max(0.2, CGFloat(level) + 50) / 2
        return Float(min(level, 25))
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        recordingTime = 0
        audioLevels = Array(repeating: 0.1, count: 20) // Reset visualizer
    }
}
