//
//  UserModels.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import Foundation
import SwiftData

// 1. An Incident Report
@Model
final class Incident {
    @Attribute(.unique) var id: String
    var officerInfo: String
    var location: String
    var notes: String
    var timestamp: Date
    var lastEdited: Date?
    
    // Link to an audio recording (One-to-One)
    @Relationship(deleteRule: .nullify) var recording: Recording?
    
    init(officerInfo: String = "", location: String = "", notes: String = "", recording: Recording? = nil) {
        self.id = UUID().uuidString
        self.officerInfo = officerInfo
        self.location = location
        self.notes = notes
        self.timestamp = Date()
        self.recording = recording
    }
}

// 2. An Audio Recording
@Model
final class Recording {
    @Attribute(.unique) var id: String
    var filename: String      // The file path on disk
    var duration: TimeInterval
    var timestamp: Date
    var customName: String?   // User can rename it later
    
    init(filename: String, duration: TimeInterval) {
        self.id = UUID().uuidString
        self.filename = filename
        self.duration = duration
        self.timestamp = Date()
    }
    
    // Helper to show a nice name
    var displayName: String {
        customName ?? timestamp.formatted(date: .abbreviated, time: .shortened)
    }
}
