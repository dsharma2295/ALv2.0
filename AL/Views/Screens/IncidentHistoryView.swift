import SwiftUI
import SwiftData
import AVFoundation

struct IncidentHistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    // Sort by date (newest first)
    @Query(sort: \Incident.date, order: .reverse) private var incidents: [Incident]
    
    @State private var searchText = ""
    
    var filteredIncidents: [Incident] {
        if searchText.isEmpty {
            return incidents
        } else {
            return incidents.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.notes.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            // 1. Background
            AuroraBackground()
            
            VStack(spacing: 0) {
                // 2. Custom Header (Safe Area Aware)
                HStack {
                    Button(action: {
                        // Force a haptic feedback and dismiss
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44) // Large touch target
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Text("History")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .tracking(1)
                    
                    Spacer()
                    
                    // Balance the header
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                .padding(.top, 60) // Add top padding for Dynamic Island/Notch
                .background(
                    LinearGradient(
                        colors: [Color.black.opacity(0.8), Color.black.opacity(0.0)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                // 3. Search & List
                if incidents.isEmpty {
                    ContentUnavailableView(
                        "No Incidents",
                        systemImage: "archivebox",
                        description: Text("Your logged reports will appear here.")
                    )
                    .foregroundStyle(.gray)
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        // Search Bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.gray)
                            TextField("Search logs...", text: $searchText)
                                .foregroundStyle(.white)
                        }
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                        
                        // List Items
                        VStack(spacing: 16) {
                            ForEach(filteredIncidents) { incident in
                                NavigationLink(destination: IncidentDetailView(incident: incident)) {
                                    IncidentRowCard(incident: incident)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
        }
        .ignoresSafeArea(.all, edges: .top) // Allow header to go behind status bar
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar) // Modern way to hide nav bar
    }
}

// MARK: - Subcomponent: Incident Row
struct IncidentRowCard: View {
    let incident: Incident
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(incident.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text(incident.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray.opacity(0.5))
            }
            
            if !incident.notes.isEmpty {
                Text(incident.notes)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineLimit(2)
            }
            
            // Evidence Badge
            if !incident.recordings.isEmpty {
                HStack {
                    Image(systemName: "waveform")
                        .font(.caption)
                        .foregroundStyle(.red)
                    Text("\(incident.recordings.count) Recording(s)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(8)
                .background(Color.red.opacity(0.1))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color.red.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    IncidentHistoryView()
        .preferredColorScheme(.dark)
}
