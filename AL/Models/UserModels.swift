import Foundation
import SwiftData

// MARK: - Recording Model
@Model
final class Recording {
    var id: String
    var filename: String
    var timestamp: Date
    var duration: TimeInterval
    
    // Relationship: One recording belongs to one incident (optional)
    var incident: Incident?
    
    var displayName: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return "Evidence \(formatter.string(from: timestamp))"
    }
    
    init(filename: String, timestamp: Date = Date(), duration: TimeInterval) {
        self.id = UUID().uuidString
        self.filename = filename
        self.timestamp = timestamp
        self.duration = duration
    }
}

// MARK: - Incident Model
@Model
final class Incident {
    var id: String
    var title: String
    var date: Date
    var location: String
    var notes: String
    var agency: String
    var badges: [String]
    
    // --- NEW PROPERTIES (Fixed Build Errors) ---
    var officerInfo: String // Was missing
    var lastEdited: Date    // Was missing
    
    // Relationship: One incident has many recordings
    @Relationship(deleteRule: .cascade, inverse: \Recording.incident)
    var recordings: [Recording] = []
    
    init(title: String = "New Incident",
         date: Date = Date(),
         location: String = "",
         notes: String = "",
         agency: String = "General",
         officerInfo: String = "") {
        
        self.id = UUID().uuidString
        self.title = title
        self.date = date
        self.location = location
        self.notes = notes
        self.agency = agency
        self.officerInfo = officerInfo
        self.badges = []
        self.lastEdited = Date()
    }
}
