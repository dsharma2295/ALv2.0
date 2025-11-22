//
//  RightsListView.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import SwiftUI

struct RightsListView: View {
    // Load the static data
    let allScenarios = ContentLoader.shared.scenarios
    
    // State for Search & Filter
    @State private var searchText = ""
    @State private var selectedState = "Massachusetts"
    
    let usStates = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
        "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
        "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
        "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
        "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
        "New Hampshire", "New Jersey", "New Mexico", "New York",
        "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
        "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
        "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming"
    ]
    
    // Filter Logic
    var filteredScenarios: [Scenario] {
        let results = allScenarios.filter { scenario in
            if searchText.isEmpty { return true }
            return scenario.title.localizedCaseInsensitiveContains(searchText) ||
                   scenario.subtitle.localizedCaseInsensitiveContains(searchText) ||
                   scenario.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }
        return results
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "map.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Color.blue.gradient)
                            .shadow(color: .blue.opacity(0.4), radius: 15)
                        
                        Text("Select Situation")
                            .font(.title2.bold())
                            .engraved()
                    }
                    .padding(.vertical, 10)
                    
                    // State Selector (Only shows if Traffic is relevant/visible)
                    HStack {
                        Text("JURISDICTION:")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                        
                        Menu {
                            Picker("State", selection: $selectedState) {
                                ForEach(usStates, id: \.self) { state in
                                    Text(state).tag(state)
                                }
                            }
                        } label: {
                            HStack {
                                Text(selectedState)
                                    .fontWeight(.semibold)
                                Image(systemName: "chevron.up.chevron.down")
                                    .font(.caption)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(white: 0.15))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule().stroke(.white.opacity(0.1), lineWidth: 1)
                            )
                            .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Scenario Cards List
                    if filteredScenarios.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    } else {
                        VStack(spacing: 16) {
                            ForEach(filteredScenarios) { scenario in
                                // Dynamic Title Adjustment for Traffic
                                let displayTitle = scenario.category == .traffic
                                    ? "\(selectedState) Traffic"
                                    : scenario.title
                                
                                NavigationLink(destination: ScenarioDetailView(scenario: scenario)) {
                                    ScenarioRow(title: displayTitle, scenario: scenario)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search rights (e.g., 'Traffic', 'CBP')")
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}

// A single row representing a scenario
struct ScenarioRow: View {
    let title: String // Allow overriding title
    let scenario: Scenario
    
    var body: some View {
        HStack(spacing: 16) {
            // Icon Container
            ZStack {
                Circle()
                    .fill(Color(white: 0.15))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle().stroke(.white.opacity(0.1), lineWidth: 1)
                    )
                
                Image(systemName: scenario.iconName)
                    .font(.title2)
                    .foregroundStyle(.white)
            }
            
            // Text Info
            VStack(alignment: .leading, spacing: 4) {
                Text(title) // Use the dynamic title
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text(scenario.subtitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding(16)
        .background(Color(white: 0.1))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        RightsListView()
            .preferredColorScheme(.dark)
    }
}
