import Foundation
import AVFoundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class AudioRecorderViewModel: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    // --- State ---
    @Published var isRecording = false
    @Published var isPlaying = false
    @Published var hasJustFinished = false
    @Published var recordingTime: TimeInterval = 0
    @Published var audioLevels: [CGFloat] = Array(repeating: 0.1, count: 30)
    @Published var savedRecordings: [Recording] = [] // Kept for internal logic, though View uses @Query now
    @Published var currentPlayingID: String? = nil
    
    // --- Internals ---
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var modelContext: ModelContext?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
    }
    
    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    // --- Recording ---
    func startRecording() {
        hasJustFinished = false
        let fileName = "evidence_\(Date().timeIntervalSince1970).m4a"
        let path = getDocumentsDirectory().appendingPathComponent(fileName)
        
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
            
            isRecording = true
            startTimer()
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            print("Started recording to: \(path)")
            
        } catch {
            print("Could not start recording: \(error)")
        }
    }
    
    func stopRecording() {
        guard let recorder = audioRecorder else { return }
        
        let duration = recorder.currentTime
        recorder.stop()
        
        isRecording = false
        stopTimer()
        
        // Save to DB
        saveRecordingToDB(filename: recorder.url.lastPathComponent, duration: duration)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        withAnimation {
            hasJustFinished = true
        }
        
        audioRecorder = nil
    }
    
    // --- Playback ---
    func playRecording(_ recording: Recording) {
        let path = getDocumentsDirectory().appendingPathComponent(recording.filename)
        
        // Verify file exists
        if !FileManager.default.fileExists(atPath: path.path) {
            print("Error: Audio file not found at \(path)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer?.delegate = self
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
            
            isPlaying = true
            currentPlayingID = recording.id
            
        } catch {
            print("Playback failed: \(error)")
        }
    }
    
    func stopPlayback() {
        audioPlayer?.stop()
        isPlaying = false
        currentPlayingID = nil
    }
    
    // --- Helpers ---
    private func startTimer() {
        recordingTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            Task { @MainActor in
                self.recordingTime += 0.1
                self.updateAudioLevels()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        recordingTime = 0
        audioLevels = Array(repeating: 0.1, count: 30)
    }
    
    private func updateAudioLevels() {
        guard let recorder = audioRecorder else { return }
        recorder.updateMeters()
        let power = recorder.averagePower(forChannel: 0)
        let normalized = normalizeSoundLevel(level: power)
        
        withAnimation(.linear(duration: 0.1)) {
            if audioLevels.count > 0 {
                audioLevels.removeFirst()
                audioLevels.append(CGFloat(normalized))
            }
        }
    }
    
    private func normalizeSoundLevel(level: Float) -> Float {
        let level = max(0.2, CGFloat(level) + 50) / 2
        return Float(min(level, 20))
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // --- Database ---
    private func saveRecordingToDB(filename: String, duration: TimeInterval) {
        guard let context = modelContext else {
            print("Error: ModelContext is nil, cannot save!")
            return
        }
        
        print("Saving recording: \(filename)")
        let newRecording = Recording(filename: filename, duration: duration)
        context.insert(newRecording)
        
        // Explicitly save to ensure persistence immediately
        do {
            try context.save()
            print("Recording saved successfully.")
        } catch {
            print("Failed to save recording to DB: \(error)")
        }
    }
    
    func deleteRecording(_ recording: Recording) {
        // Maintained for compatibility if used elsewhere
        guard let context = modelContext else { return }
        let path = getDocumentsDirectory().appendingPathComponent(recording.filename)
        try? FileManager.default.removeItem(at: path)
        context.delete(recording)
        try? context.save()
    }
}
