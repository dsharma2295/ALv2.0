import SwiftUI

struct TrafficStateSelectionView: View {
    let availableStates = ["Massachusetts"]
    
    var body: some View {
        ZStack {
            // Consistent Background
            AuroraBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(availableStates, id: \.self) { state in
                        if let agency = DataLoader.shared.getTrafficAgency(state: state) {
                            NavigationLink(destination: AgencyHubView(agency: agency)) {
                                HStack {
                                    Text(state)
                                        .font(.title3)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.gray)
                                }
                                .padding()
                                .glass(cornerRadius: 16) // <--- UPDATED
                            }
                        } else {
                            HStack {
                                Text(state)
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                                Spacer()
                                Text("Coming Soon")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            .padding()
                            .glass(cornerRadius: 16) // <--- UPDATED
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Select State")
    }
}
