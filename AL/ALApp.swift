import SwiftUI
import SwiftData

@main
struct ALApp: App {
    // Initialize the Database
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

    var body: some Scene {
        WindowGroup {
            HomeView() // Point to our new Home
        }
        .modelContainer(sharedModelContainer)
    }
}
