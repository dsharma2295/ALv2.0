import SwiftUI
import SwiftData

struct IncidentLoggerView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // --- State Variables (Must match the Init call below) ---
    @State private var title = ""
    @State private var date = Date()
    @State private var location = ""
    @State private var notes = ""
    @State private var agency = ""
    @State private var officerInfo = ""
    
    var body: some View {
        ZStack {
            // 1. The Premium Animated Background
            AuroraBackground()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    HStack {
                        Button("Cancel") { dismiss() }
                            .foregroundStyle(.red)
                        Spacer()
                        Text("New Incident")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                        Button("Save") { saveIncident() }
                            .fontWeight(.bold)
                            .foregroundStyle(.blue)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    
                    // Form Fields Container
                    VStack(spacing: 20) {
                        
                        // Section 1: Basics
                        VStack(alignment: .leading, spacing: 10) {
                            Text("DETAILS")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            GlassTextField(placeholder: "Title (e.g., Traffic Stop)", text: $title)
                            
                            DatePicker("Date & Time", selection: $date)
                                .colorScheme(.dark) // Force dark picker
                                .padding()
                                .glass(cornerRadius: 12)
                            
                            GlassTextField(placeholder: "Location (e.g., I-95 Exit 4)", text: $location)
                        }
                        
                        // Section 2: Officer & Agency
                        VStack(alignment: .leading, spacing: 10) {
                            Text("AUTHORITY")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            GlassTextField(placeholder: "Agency (e.g., NYPD, TSA)", text: $agency)
                            GlassTextField(placeholder: "Officer Name / Badge #", text: $officerInfo)
                        }
                        
                        // Section 3: Notes
                        VStack(alignment: .leading, spacing: 10) {
                            Text("NOTES")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.white.opacity(0.6))
                            
                            TextEditor(text: $notes)
                                .frame(height: 120)
                                .scrollContentBackground(.hidden)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.white.opacity(0.1), lineWidth: 1)
                                )
                                .foregroundStyle(.white)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    // --- The Logic ---
    private func saveIncident() {
        let newIncident = Incident(
            title: title.isEmpty ? "Untitled Incident" : title,
            date: date,
            location: location, // Correct Order: location is 3rd
            notes: notes,       // notes is 4th
            agency: agency,     // agency is 5th
            officerInfo: officerInfo // officerInfo is 6th
        )
        
        modelContext.insert(newIncident)
        dismiss()
    }
}

// Helper for nice Glass Text Fields
struct GlassTextField: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundColor(.gray))
            .foregroundStyle(.white)
            .padding()
            .glass(cornerRadius: 12)
    }
}

#Preview {
    IncidentLoggerView()
        .preferredColorScheme(.dark)
}
