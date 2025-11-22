
//  KnowledgeModels.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import Foundation
import SwiftUI

// 1. Categories for your scenarios (Traffic, Customs, etc.)
enum AgencyCategory: String, Codable, CaseIterable {
    case traffic = "traffic"
    case customs = "customs"
    case tsa = "tsa"             // Future proofing
    case federal = "federal"     // Future proofing
}

// 2. Priority levels for rights cards (Critical = Red, etc.)
enum RightPriority: String, Codable {
    case critical // High alert
    case important // Medium alert
    case info     // Low alert
    
    var color: Color {
        switch self {
        case .critical: return .red
        case .important: return .orange
        case .info: return .gray
        }
    }
}

// 3. The Data Structure for a Scenario (e.g., "MA Traffic Stop")
struct Scenario: Identifiable, Codable {
    var id: String
    var title: String
    var subtitle: String
    var category: AgencyCategory
    var iconName: String // SF Symbol name
    var rights: [RightCard]
    var quickPhrases: [QuickPhrase]
}

// 4. A single Right Card (e.g., "Right to Silence")
struct RightCard: Identifiable, Codable {
    var id: String
    var title: String
    var summary: String
    var content: String
    var legalBasis: String
    var priority: RightPriority
}

// 5. Quick Phrases for the heat of the moment
struct QuickPhrase: Identifiable, Codable {
    var id: String
    var situation: String
    var phrase: String
    var explanation: String
}
