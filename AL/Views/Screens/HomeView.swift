import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var audioVM = AudioRecorderViewModel.shared
    
    // Navigation State
    @State private var selectedIndex = 0
    @State private var showSOSAlert = false
    @State private var navigateToLocations = false
    @State private var navigateToHistory = false
    @State private var showLoggerSheet = false
    
    // Carousel Data
    let carouselItems: [CarouselItem] = [
        CarouselItem(
            id: "location",
            title: "Where are you?",
            subtitle: "Identify your situation",
            icon: "map.fill",
            color: .blue,
            action: .navigate
        ),
        CarouselItem(
            id: "log",
            title: "Log Incident",
            subtitle: "Document violation",
            icon: "square.and.pencil",
            color: .green,
            action: .sheet
        ),
        CarouselItem(
            id: "history",
            title: "History",
            subtitle: "Past Reports & Logs",
            icon: "archivebox.fill",
            color: .purple,
            action: .navigate
        )
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 1. Background
                AuroraBackground()
                
                VStack(spacing: 0) {
                    // 2. Header
                    HomeHeaderView()
                    
                    Spacer()
                    
                    // 3. Carousel
                    CarouselView(selectedIndex: $selectedIndex, items: carouselItems) { item in
                        handleCarouselTap(item)
                    }
                    
                    // 4. Page Indicator
                    PageIndicatorView(selectedIndex: selectedIndex, count: carouselItems.count)
                        .padding(.bottom, 40)
                    
                    Spacer()
                    
                    // 5. Bottom Control Bar
                    BottomControlBar(
                        audioVM: audioVM,
                        onSOSTap: triggerSOS,
                        onRecordTap: toggleRecording
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                }
            }
            // --- Navigation Links ---
            .navigationDestination(isPresented: $navigateToLocations) {
                LocationsView()
            }
            .navigationDestination(isPresented: $navigateToHistory) {
                IncidentHistoryView()
            }
            // --- Sheets ---
            .sheet(isPresented: $showLoggerSheet) {
                IncidentLoggerView()
            }
            // --- Alerts ---
            .alert("SOS TRIGGERED", isPresented: $showSOSAlert) {
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Emergency contacts have been notified (Simulation).")
            }
        }
        .onAppear {
            audioVM.setModelContext(modelContext)
        }
    }
    
    // MARK: - Actions
    
    func handleCarouselTap(_ item: CarouselItem) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        switch item.id {
        case "location":
            navigateToLocations = true
        case "log":
            showLoggerSheet = true
        case "history":
            navigateToHistory = true
        default:
            break
        }
    }
    
    func triggerSOS() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        showSOSAlert = true
    }
    
    func toggleRecording() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if audioVM.isRecording {
            audioVM.stopRecording()
        } else {
            audioVM.startRecording()
        }
    }
}

// MARK: - Subviews

struct HomeHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(Date().formatted(date: .complete, time: .omitted).uppercased())
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.5))
                    .tracking(1)
                
                Text("AL")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
            Spacer()
            
            NavigationLink(destination: Text("Settings")) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }
}

struct CarouselView: View {
    @Binding var selectedIndex: Int
    let items: [CarouselItem]
    let tapAction: (CarouselItem) -> Void
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            ForEach(0..<items.count, id: \.self) { index in
                Button(action: { tapAction(items[index]) }) {
                    HeroCard(item: items[index])
                }
                .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 420)
        .padding(.bottom, 20)
    }
}

struct PageIndicatorView: View {
    let selectedIndex: Int
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(Color.white.opacity(selectedIndex == index ? 1 : 0.2))
                    .frame(width: selectedIndex == index ? 20 : 8, height: 8)
                    .animation(.spring(), value: selectedIndex)
            }
        }
    }
}

struct BottomControlBar: View {
    @ObservedObject var audioVM: AudioRecorderViewModel
    let onSOSTap: () -> Void
    let onRecordTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // SOS Button
            Button(action: onSOSTap) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                    
                    VStack(spacing: 2) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 22))
                        Text("SOS")
                            .font(.system(size: 10, weight: .black))
                    }
                    .foregroundStyle(Color.red.gradient)
                }
                .frame(width: 72, height: 72)
                .overlay(Circle().stroke(Color.red.opacity(0.3), lineWidth: 1))
            }
            
            // Record Pill
            RecordControlPill(audioVM: audioVM, onRecordTap: onRecordTap)
            
            // Bookmarks Button
            NavigationLink(destination: BookmarksView()) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.3), radius: 10, y: 5)
                    
                    VStack(spacing: 2) {
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(.white)
                        Text("SAVED")
                            .font(.system(size: 10, weight: .black))
                            .foregroundStyle(.white)
                    }
                }
                .frame(width: 72, height: 72)
                .overlay(Circle().stroke(Color.orange.opacity(0.3), lineWidth: 1))
            }
        }
    }
}

struct RecordControlPill: View {
    @ObservedObject var audioVM: AudioRecorderViewModel
    let onRecordTap: () -> Void
    @State private var pulse = false // Local state for pulsing animation
    
    var body: some View {
        HStack(spacing: 0) {
            // Record Action
            Button(action: onRecordTap) {
                HStack {
                    if audioVM.isRecording {
                        // Active State: Waveform
                        HStack(spacing: 3) {
                            ForEach(0..<6, id: \.self) { index in
                                let levelIndex = index % audioVM.audioLevels.count
                                let height = audioVM.audioLevels[levelIndex] * 1.5 + 5
                                
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.white)
                                    .frame(width: 4, height: height)
                                    .animation(.easeInOut(duration: 0.1), value: height)
                            }
                        }
                        .frame(width: 50)
                        
                        Text(formatDuration(audioVM.recordingTime))
                            .font(.system(.headline, design: .monospaced))
                            .foregroundStyle(.white)
                            .frame(width: 60)
                        
                    } else {
                        // Idle State
                        Image(systemName: "mic.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding(.leading, 14) // Adjusted padding
                        
                        Text("Record")
                            .font(.system(.headline, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.leading, 4)
                            .lineLimit(1)            // Fix: Prevent wrapping
                            .minimumScaleFactor(0.8) // Fix: Allow slight shrink
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 72)
                // FIX: Use AnyShapeStyle to handle mismatched types
                .background(
                    audioVM.isRecording
                        ? AnyShapeStyle(Color.black.opacity(0.8))
                        : AnyShapeStyle(Color.red.gradient)
                )
            }
            
            // Separator
            Rectangle()
                .fill(Color.white.opacity(0.2))
                .frame(width: 1, height: 40)
            
            // Log Access
            NavigationLink(destination: AudioRecorderView()) {
                VStack(spacing: 2) {
                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 20))
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Log")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .frame(width: 64, height: 72)
                .background(
                    audioVM.isRecording
                        ? AnyShapeStyle(Color.black.opacity(0.8))
                        : AnyShapeStyle(Color.red.gradient)
                )
            }
        }
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(audioVM.isRecording ? Color.red : Color.white.opacity(0.15), lineWidth: 1)
        )
        // Pulsating Ring Effect
        .overlay(
            Group {
                if audioVM.isRecording {
                    Capsule()
                        .stroke(Color.red.opacity(0.5), lineWidth: 4)
                        .scaleEffect(pulse ? 1.1 : 1.0)
                        .opacity(pulse ? 0.0 : 1.0)
                        .onAppear {
                            withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                                pulse = true
                            }
                        }
                }
            }
        )
        .shadow(color: audioVM.isRecording ? .red.opacity(0.5) : .red.opacity(0.4), radius: 15, y: 5)
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let mins = Int(duration) / 60
        let secs = Int(duration) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

// MARK: - Subcomponents (Data Models)

struct CarouselItem: Identifiable, Hashable {
    enum ActionType { case navigate, sheet }
    let id: String
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: ActionType
}

struct HeroCard: View {
    let item: CarouselItem
    
    var body: some View {
        ZStack {
            // Glass Background
            RoundedRectangle(cornerRadius: 40, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.4), radius: 30, x: 0, y: 15)
            
            // Content
            VStack(spacing: 30) {
                // Floating Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [item.color.opacity(0.2), .clear],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 140, height: 140)
                        .blur(radius: 20)
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 80))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, item.color],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .shadow(color: item.color.opacity(0.5), radius: 15)
                }
                
                // Text
                VStack(spacing: 12) {
                    Text(item.title)
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)
                    
                    Text(item.subtitle.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.6))
                        .tracking(2)
                }
            }
            .padding(20)
        }
        .padding(.horizontal, 20)
        .frame(width: 340)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Recording.self, Incident.self, configurations: config)
        return HomeView()
            .modelContainer(container)
            .preferredColorScheme(.dark)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}
