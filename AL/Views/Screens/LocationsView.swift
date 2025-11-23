import SwiftUI

struct LocationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            AuroraBackground() // Keep the premium background
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // 1. Airport Card
                    NavigationLink(destination: AgencyListView(category: .airport)) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "airplane.departure")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                Text("Airport / Port")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text("CBP • TSA • ICE • HSI")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .glass(cornerRadius: 24)
                    }
                    
                    // 2. Traffic Card
                    NavigationLink(destination: TrafficStateSelectionView()) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "car.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                                
                                Text("Traffic Stop")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                                
                                Text("STATE POLICE • HIGHWAY PATROL")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.title2)
                                .foregroundStyle(.gray)
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            LinearGradient(
                                colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .glass(cornerRadius: 24)
                    }
                    
                    // 3. Home Warrant (Disabled/Coming Soon)
                    Button(action: {}) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Image(systemName: "house.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.gray)
                                
                                Text("Home Warrant")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                                
                                Text("COMING SOON")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(6)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Capsule())
                                    .foregroundStyle(.gray)
                            }
                            Spacer()
                        }
                        .padding(30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(white: 0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white.opacity(0.05), lineWidth: 1)
                        )
                    }
                    .disabled(true)
                }
                .padding(20)
            }
        }
        .navigationTitle("Current Situation")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    LocationsView()
        .preferredColorScheme(.dark)
}
