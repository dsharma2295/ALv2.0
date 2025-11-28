import SwiftUI
import SwiftData
import AVFoundation

@main
struct ALApp: App {
    @State private var showSplashScreen = true
    
    // Initialize Database
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Incident.self,
            Recording.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        // Setup Audio Session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session error: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplashScreen {
                    SplashScreenView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                        .zIndex(1)
                } else {
                    HomeView()
                        .transition(.opacity.animation(.easeInOut(duration: 0.5)))
                        .zIndex(0)
                }
            }
            .modelContainer(sharedModelContainer)
            .preferredColorScheme(.dark)
            .task {
                // Hold Splash for exactly 2 seconds
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                withAnimation {
                    showSplashScreen = false
                }
            }
        }
    }
}
