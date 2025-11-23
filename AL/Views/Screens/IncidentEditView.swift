//
//  IncidentEditView.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/22/25.
//
import SwiftUI
import SwiftData

struct IncidentEditView: View {
    @Environment(\.dismiss) private var dismiss
    
    // We bind directly to the Incident object for live updates
    @Bindable var incident: Incident
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        
                        // Header
                        Text("Edit Report")
                            .font(Font.headline)
                            .engraved()
                            .padding(.top)
                        
                        // Form Fields (Reusing your TacticalInput)
                        VStack(spacing: 16) {
                            TacticalInput(
                                title: "Officer Information",
                                placeholder: "Badge #, Name",
                                text: $incident.officerInfo,
                                icon: "person.badge.shield.check.fill"
                            )
                            
                            TacticalInput(
                                title: "Location",
                                placeholder: "Address or Coordinates",
                                text: $incident.location,
                                icon: "mappin.and.ellipse"
                            )
                            
                            TacticalInput(
                                title: "Narrative",
                                placeholder: "Incident details...",
                                text: $incident.notes,
                                icon: "note.text",
                                isMultiLine: true
                            )
                            
                            // Date Picker Container
                            VStack(alignment: .leading, spacing: 8) {
                                Label("DATE & TIME", systemImage: "calendar")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                                
                                DatePicker("", selection: $incident.date)
                                    .labelsHidden()
                                    .colorScheme(.dark)
                                    .padding()
                                    .background(Color(white: 0.12))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal, 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        incident.lastEdited = Date() // Timestamp the edit
                        dismiss()
                    }
                    .fontWeight(.bold)
                }
            }
        }
    }
}
