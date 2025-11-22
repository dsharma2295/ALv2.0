import SwiftUI
import SwiftData

struct HomeView: View {
    // --- Database & ViewModel ---
    @Environment(\.modelContext) private var modelContext
    @StateObject private var audioVM = AudioRecorderViewModel()
    
    // --- Navigation State ---
    @State private var navigateToRecorder = false // Auto-nav after recording
    @State private var navigateToLog = false      // Manual nav to log
    
    // Data for the carousel
    let menuItems = [
        MenuItem(id: "rights", title: "Where Are You?", icon: "location.fill", color: .blue),
        MenuItem(id: "incident", title: "Log Incident", icon: "doc.text.fill", color: .green),
        MenuItem(id: "bookmarks", title: "Saved Items", icon: "bookmark.fill", color: .orange)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Deep Black Background
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 2. Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("AL")
                                .font(.system(size: 34, weight: .heavy))
                                .engraved()
                            Text("LEGAL ASSISTANT")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.gray)
                                .tracking(2)
                        }
                        Spacer()
                        Button(action: { /* Open Settings */ }) {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                                .foregroundStyle(Color(white: 0.3))
                                .padding(10)
                                .background(Color(white: 0.1))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // 3. The 3D Carousel
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(menuItems) { item in
                                NavigationLink(value: item) {
                                    MenuCard(item: item)
                                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                                        .scrollTransition { content, phase in
                                            content
                                                .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                                .opacity(phase.isIdentity ? 1.0 : 0.6)
                                                .blur(radius: phase.isIdentity ? 0 : 2)
                                        }
                                }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(.horizontal, 40, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                    .frame(height: 400)
                    
                    // --- Navigation Handling ---
                    .navigationDestination(for: MenuItem.self) { item in
                        if item.id == "incident" {
                            IncidentLoggerView()
                        } else if item.id == "rights" {
                            RightsListView()
                        } else {
                            ContentUnavailableView("Coming Soon", systemImage: "clock", description: Text("This feature is under development."))
                        }
                    }
                    .navigationDestination(isPresented: $navigateToRecorder) {
                        AudioRecorderView()
                    }
                    .navigationDestination(isPresented: $navigateToLog) {
                        AudioRecorderView()
                    }
                    
                    Spacer()
                    
                    // 4. Split Action Bar
                    HStack(spacing: 16) {
                        
                        // === SPLIT RECORD BUTTON ===
                        HStack(spacing: 0) {
                            // A. Record/Stop Zone
                            Button(action: handleRecordButtonTap) {
                                HStack {
                                    if audioVM.isRecording {
                                        HStack(spacing: 3) {
                                            ForEach(0..<12, id: \.self) { index in
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color.white)
                                                    .frame(width: 3, height: CGFloat(audioVM.audioLevels[index] * 1.5 + 5))
                                                    .animation(.easeOut(duration: 0.1), value: audioVM.audioLevels)
                                            }
                                        }
                                        .frame(width: 60)
                                        
                                        Text("STOP")
                                            .font(.headline)
                                            .fontWeight(.black)
                                            .foregroundStyle(.white)
                                            .padding(.leading, 8)
                                        
                                    } else if audioVM.hasJustFinished {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                        Text("SAVED")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                            .foregroundStyle(.white)
                                            .padding(.leading, 4)
                                        
                                    } else {
                                        Image(systemName: "mic.fill")
                                            .font(.title2)
                                            .foregroundStyle(.white)
                                        VStack(alignment: .leading) {
                                            Text("Record")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.white)
                                            Text("Evidence")
                                                .font(.caption2)
                                                .foregroundStyle(.white.opacity(0.7))
                                        }
                                        .padding(.leading, 4)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(.leading, 20)
                                .frame(maxHeight: .infinity)
                            }
                            
                            // Vertical Divider
                            Rectangle()
                                .fill(Color.black.opacity(0.2))
                                .frame(width: 1)
                                .padding(.vertical, 12)
                            
                            // B. Log Access Zone
                            Button(action: {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                navigateToLog = true
                            }) {
                                ZStack {
                                    Color.black.opacity(0.001) // Hit box
                                    Image(systemName: "list.bullet.circle.fill")
                                        .font(.title2)
                                        .foregroundStyle(.white.opacity(0.9))
                                }
                                .frame(width: 60, height: 76)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 76)
                        .background(
                            audioVM.isRecording ? Color.red.gradient :
                            (audioVM.hasJustFinished ? Color.green.gradient : Color.red.gradient)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: audioVM.isRecording ? .red.opacity(0.5) : .red.opacity(0.3), radius: 10, y: 5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white.opacity(0.15), lineWidth: 1)
                        )
                        
                        // SOS Button
                        Button(action: {
                            // Trigger SOS
                        }) {
                            VStack(spacing: 2) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.title2)
                                Text("SOS").font(.caption2).fontWeight(.black)
                            }
                            .frame(width: 76, height: 76)
                            .background(Color(white: 0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24).stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                        }
                        .buttonStyle(BouncyButtonStyle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            audioVM.setModelContext(modelContext)
        }
    }
    
    // Logic for the main record button
    private func handleRecordButtonTap() {
        if audioVM.isRecording {
            audioVM.stopRecording()
        } else if audioVM.hasJustFinished {
            navigateToRecorder = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                audioVM.hasJustFinished = false
            }
        } else {
            audioVM.startRecording()
        }
    }
}

// --- Subcomponents ---

struct MenuCard: View {
    let item: MenuItem
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: item.icon)
                .font(.system(size: 80))
                .foregroundStyle(item.color.gradient)
                .shadow(color: item.color.opacity(0.5), radius: 20)
            
            Text(item.title)
                .font(.title.bold())
                .engraved()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 380)
        .metallic()
        .padding(.horizontal, 10)
    }
}

struct MenuItem: Identifiable, Hashable {
    var id: String
    var title: String
    var icon: String
    var color: Color
}

#Preview {
    HomeView()
        .preferredColorScheme(.dark)
}
