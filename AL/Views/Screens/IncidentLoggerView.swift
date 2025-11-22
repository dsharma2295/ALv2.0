//
//  IncidentLoggerView.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import SwiftUI
import SwiftData

struct IncidentLoggerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Form State
    @State private var officerInfo = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var timestamp = Date()
    
    var body: some View {
        ZStack {
            // Background
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // 1. Header
                    VStack(spacing: 8) {
                        Image(systemName: "document.badge.plus")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.green.gradient)
                            .shadow(color: .green.opacity(0.4), radius: 15)
                        
                        Text("Log Incident")
                            .font(.title2.bold())
                            .engraved()
                    }
                    .padding(.vertical, 20)
                    
                    // 2. The Form Container
                    VStack(spacing: 20) {
                        
                        // Date Time Picker (Styled)
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundStyle(.gray)
                            Text("DATE & TIME")
                                .font(.caption.bold())
                                .foregroundStyle(.gray)
                                .tracking(1)
                            Spacer()
                            DatePicker("", selection: $timestamp)
                                .labelsHidden()
                                .colorScheme(.dark) // Forces dark picker
                        }
                        .padding()
                        .background(Color(white: 0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
                        // Inputs
                        TacticalInput(
                            title: "Officer Information",
                            placeholder: "Badge #, Name, Car #",
                            text: $officerInfo,
                            icon: "person.text.rectangle.fill"
                        )
                        
                        TacticalInput(
                            title: "Location",
                            placeholder: "Street, Landmark, or GPS",
                            text: $location,
                            icon: "mappin.and.ellipse"
                        )
                        
                        TacticalInput(
                            title: "Narrative",
                            placeholder: "Describe what happened...",
                            text: $notes,
                            icon: "note.text",
                            isMultiLine: true
                        )
                        
                        // Audio Attachment Placeholder (We will link this later)
                        Button(action: {
                            // TODO: Open Audio Picker
                        }) {
                            HStack {
                                Image(systemName: "waveform")
                                Text("Attach Audio Evidence")
                                Spacer()
                                Image(systemName: "plus.circle.fill")
                            }
                            .padding()
                            .background(Color(white: 0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                            .foregroundStyle(.blue)
                        }
                    }
                    .padding(20)
                    .background(Material.thin) // Glass background for form
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.horizontal)
                    
                    // 3. Save Action
                    Button(action: saveIncident) {
                        Text("SAVE REPORT")
                            .font(.headline)
                            .tracking(2)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green.gradient)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .green.opacity(0.4), radius: 10, y: 5)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
    
    // Database Logic
    private func saveIncident() {
        let newIncident = Incident(
            officerInfo: officerInfo,
            location: location,
            notes: notes
        )
        newIncident.timestamp = timestamp
        
        // Save to SwiftData
        modelContext.insert(newIncident)
        
        // Provide Haptic Feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss() // Close screen
    }
}

#Preview {
    IncidentLoggerView()
        .preferredColorScheme(.dark)
}
