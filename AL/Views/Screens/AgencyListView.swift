import SwiftUI

struct AgencyListView: View {
    let category: AgencyCategory
    
    var agencies: [Agency] {
        DataLoader.shared.getAgencies(category: category)
    }
    
    var body: some View {
        ZStack {
            // Consistent Background
            AuroraBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Header
                    Text("Select Agency")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Agency Cards
                    VStack(spacing: 16) {
                        ForEach(agencies) { agency in
                            NavigationLink(destination: AgencyHubView(agency: agency)) {
                                HStack(spacing: 16) {
                                    // Glass Icon Box
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.white.opacity(0.1))
                                            .frame(width: 56, height: 56)
                                        
                                        Text(String(agency.shortName.prefix(1)))
                                            .font(.title2)
                                            .fontWeight(.heavy)
                                            .foregroundStyle(.white)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(agency.shortName)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(agency.name)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.7))
                                            .lineLimit(1)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.white.opacity(0.3))
                                }
                                .padding(16)
                                .glass(cornerRadius: 20) // Uses our new glass modifier
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
