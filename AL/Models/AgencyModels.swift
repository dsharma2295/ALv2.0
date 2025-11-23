import Foundation
import SwiftUI

// MARK: - Enums

enum AgencyCategory: String, Codable, CaseIterable, Identifiable {
    case airport = "Airport"
    case traffic = "Traffic"
    // Expandable: case home = "Home", case publicSpace = "Public Space"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .airport: return "airplane"
        case .traffic: return "car.fill"
        }
    }
}

enum ContentPriority: String, Codable {
    case critical // Red
    case important // Orange
    case info // Blue
    
    var color: Color {
        switch self {
        case .critical: return .red
        case .important: return .orange
        case .info: return .blue
        }
    }
}

// MARK: - Models

struct Agency: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var shortName: String
    var category: AgencyCategory
    var description: String
    var websiteURL: String
    var about: String // For the floating 'i' button
    
    // Hierarchy Data
    var canDo: [ContentCard]
    var cannotDo: [ContentCard]
    var rights: [ContentCard]
    var quickPhrases: [QuickPhrase]
    
    // Optional: For Traffic states
    var state: String?
}

struct ContentCard: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var summary: String
    var detail: String
    var legalBasis: String
    var sourceURL: String?
    var priority: ContentPriority
}

struct QuickPhrase: Identifiable, Codable, Hashable {
    var id: String
    var situation: String
    var phrase: String
    var explanation: String
}
