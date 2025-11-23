import SwiftUI
import AVFoundation

struct IncidentDetailView: View {
    let incident: Incident
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // State
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying = false
    @State private var showEditSheet = false
    @State private var pdfURL: URL?
    @State private var showShareSheet = false
    
    var body: some View {
        ZStack {
            // 1. Premium Background
            AuroraBackground()
            
            VStack(spacing: 0) {
                
                // 2. Custom Header (Replaces System Nav Bar)
                HStack {
                    // Back Button
                    Button(action: {
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("INCIDENT REPORT")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                        .tracking(2)
                    
                    Spacer()
                    
                    // Edit Button
                    Button(action: { showEditSheet = true }) {
                        Text("Edit")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.blue.opacity(0.3), lineWidth: 1))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 60) // Push down for Dynamic Island/Notch
                .padding(.bottom, 16)
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.8), Color.black.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // 3. Scrollable Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        // Date & Time Hero
                        VStack(alignment: .leading, spacing: 8) {
                            Text(incident.title)
                                .font(.system(size: 32, weight: .heavy))
                                .foregroundStyle(.white)
                            
                            Text(incident.date.formatted(date: .long, time: .standard))
                                .font(.headline)
                                .foregroundStyle(.gray)
                            
                            // --- THE FIX: Cast to 'Date?' so 'if let' always works ---
                            if let edited = incident.lastEdited as Date? {
                                Text("Last edited: \(edited.formatted())")
                                    .font(.caption2)
                                    .foregroundStyle(.gray.opacity(0.5))
                                    .italic()
                            }
                        }
                        .padding(.top, 10)
                        
                        // Info Sections
                        Group {
                            DetailSection(title: "OFFICER INFO", content: incident.officerInfo, icon: "person.badge.shield.check.fill")
                            
                            DetailSection(title: "LOCATION", content: incident.location, icon: "mappin.circle.fill")
                            
                            // Audio Evidence Section
                            if !incident.recordings.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Label("AUDIO EVIDENCE", systemImage: "waveform.circle.fill")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.gray)
                                        .tracking(1)
                                    
                                    ForEach(incident.recordings) { recording in
                                        Button(action: {
                                            if isPlaying {
                                                audioPlayer?.stop()
                                                isPlaying = false
                                            } else {
                                                playAudio(recording)
                                            }
                                        }) {
                                            HStack {
                                                Image(systemName: isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                                    .font(.title)
                                                    .foregroundStyle(isPlaying ? .red : .green)
                                                
                                                VStack(alignment: .leading) {
                                                    Text(recording.displayName)
                                                        .fontWeight(.bold)
                                                        .foregroundStyle(.white)
                                                    Text(formatDuration(recording.duration))
                                                        .font(.caption)
                                                        .foregroundStyle(.gray)
                                                }
                                                Spacer()
                                            }
                                            .padding()
                                            .glass(cornerRadius: 16)
                                        }
                                    }
                                }
                            }
                            
                            DetailSection(title: "NARRATIVE", content: incident.notes, icon: "note.text")
                        }
                        
                        // PDF Export
                        Button(action: generatePDF) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Export PDF Report")
                                    .fontWeight(.bold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.gradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .blue.opacity(0.4), radius: 10, y: 5)
                        }
                        .padding(.vertical, 40)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top)
        .navigationBarHidden(true)
        .sheet(isPresented: $showEditSheet) {
            IncidentEditView(incident: incident)
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL {
                ShareSheet(activityItems: [url])
            }
        }
    }
    
    // --- Logic ---
    
    private func playAudio(_ recording: Recording) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(recording.filename)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: path)
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Play error: \(error)")
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let min = Int(duration) / 60
        let sec = Int(duration) % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    private func generatePDF() {
        if let url = PDFGenerator.generateReport(for: incident) {
            self.pdfURL = url
            self.showShareSheet = true
        }
    }
}

// MARK: - Helper Components

struct DetailSection: View {
    let title: String
    let content: String
    let icon: String
    
    var body: some View {
        if !content.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                Label(title, systemImage: icon)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .tracking(1)
                
                Text(content)
                    .font(.body)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .glass(cornerRadius: 16)
            }
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    // Placeholder for preview
    Text("Detail View")
}
