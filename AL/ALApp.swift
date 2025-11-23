import SwiftUI
import SwiftData

@main
struct ALApp: App {
    // Initialize the database
    let container: ModelContainer
    
    init() {
        do {
            // Ensure these match the models in UserModels.swift
            let schema = Schema([
                Recording.self,
                Incident.self
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            // --- THE FIX: Change LocationsView() to HomeView() ---
            HomeView()
                .preferredColorScheme(.dark) // Force Dark Mode for the premium look
        }
        .modelContainer(container) // Inject the database
    }
}
