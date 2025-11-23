import SwiftUI
import SwiftData
import AVFoundation

struct AudioRecorderView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // --- THE FIX: Use @Query to auto-fetch data ---
    @Query(sort: \Recording.timestamp, order: .reverse) private var recordings: [Recording]
    
    // We keep the VM *only* for playback logic now, not for fetching
    @ObservedObject private var viewModel = AudioRecorderViewModel.shared
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color(white: 0.15))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 4) {
                        Text("EVIDENCE LOG")
                            .font(.headline)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                            .tracking(2)
                        Text("\(recordings.count) FILES SECURED") // Dynamic Count
                            .font(.caption2)
                            .foregroundStyle(.green)
                            .tracking(1)
                    }
                    
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding()
                .background(Color(white: 0.1))
                
                // 2. The List (Powered by @Query)
                if recordings.isEmpty {
                    ContentUnavailableView(
                        "No Evidence Found",
                        systemImage: "mic.slash",
                        description: Text("Recordings saved from the Home Screen will appear here.")
                    )
                } else {
                    List {
                        ForEach(recordings) { recording in
                            HStack(spacing: 16) {
                                // Play/Stop Button
                                Button(action: {
                                    // Toggle Playback
                                    if viewModel.currentPlayingID == recording.id && viewModel.isPlaying {
                                        viewModel.stopPlayback()
                                    } else {
                                        viewModel.playRecording(recording)
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(white: 0.15))
                                            .frame(width: 44, height: 44)
                                            .overlay(Circle().stroke(.white.opacity(0.1), lineWidth: 1))
                                        
                                        Image(systemName: viewModel.currentPlayingID == recording.id && viewModel.isPlaying ? "stop.fill" : "play.fill")
                                            .foregroundStyle(viewModel.currentPlayingID == recording.id ? Color.green : Color.white)
                                            .font(.title3)
                                    }
                                }
                                .buttonStyle(.plain)
                                
                                // Info
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(recording.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .lineLimit(1)
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .font(.caption2)
                                        Text(timeString(from: recording.duration))
                                            .font(.caption)
                                            .monospacedDigit()
                                        
                                        Text("•")
                                        
                                        Text(recording.timestamp.formatted(date: .abbreviated, time: .shortened))
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                    }
                                    .foregroundStyle(.gray)
                                }
                                
                                Spacer()
                                
                                // Share Action
                                ShareLink(item: getFileUrl(for: recording)) {
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundStyle(.blue)
                                        .padding(10)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.vertical, 8)
                            .listRowBackground(Color.clear)
                            .listRowSeparatorTint(Color.white.opacity(0.1))
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listStyle(.plain)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // Helper Functions
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let recording = recordings[index]
                // 1. Delete File
                let path = getFileUrl(for: recording)
                try? FileManager.default.removeItem(at: path)
                // 2. Delete from DB
                modelContext.delete(recording)
            }
        }
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func getFileUrl(for recording: Recording) -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recording.filename)
    }
}

#Preview {
    AudioRecorderView()
        .preferredColorScheme(.dark)
}
