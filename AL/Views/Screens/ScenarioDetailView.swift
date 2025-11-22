import SwiftUI

struct ScenarioDetailView: View {
    let scenario: Scenario
    @State private var selectedTab = 0 // 0 = Rights, 1 = Phrases
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Custom Segmented Control (Tactical Toggle)
                HStack(spacing: 0) {
                    TabButton(title: "LEGAL RIGHTS", isSelected: selectedTab == 0) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = 0
                        }
                    }
                    
                    // Divider
                    Rectangle()
                        .fill(Color(white: 0.2))
                        .frame(width: 1, height: 24)
                    
                    TabButton(title: "QUICK PHRASES", isSelected: selectedTab == 1) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = 1
                        }
                    }
                }
                .padding(4)
                .background(Color(white: 0.1))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.1), lineWidth: 1)
                )
                .padding()
                
                // 2. Content Scroll
                ScrollView {
                    VStack(spacing: 20) {
                        if selectedTab == 0 {
                            // RIGHTS LIST
                            ForEach(scenario.rights) { right in
                                RightInfoCard(right: right)
                                    .transition(.move(edge: .leading).combined(with: .opacity))
                            }
                        } else {
                            // PHRASES LIST
                            if scenario.quickPhrases.isEmpty {
                                ContentUnavailableView("No Phrases", systemImage: "text.bubble", description: Text("No quick responses available for this scenario."))
                            } else {
                                ForEach(scenario.quickPhrases) { phrase in
                                    QuickPhraseCard(phrase: phrase)
                                        .transition(.move(edge: .trailing).combined(with: .opacity))
                                }
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 100) // <--- FIXED HERE (removed quotes)
                }
            }
        }
        .navigationTitle(scenario.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// --- Subcomponents ---

struct RightInfoCard: View {
    let right: RightCard
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header: Title + Priority Badge
            HStack(alignment: .top) {
                Text(right.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
                
                Text(right.priority.rawValue.uppercased())
                    .font(.system(size: 10, weight: .heavy))
                    .tracking(1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(right.priority.color.opacity(0.2))
                    .foregroundStyle(right.priority.color)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6).stroke(right.priority.color.opacity(0.5), lineWidth: 1)
                    )
            }
            
            // Summary (The "TL;DR")
            Text(right.summary)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color(white: 0.9))
            
            Divider().background(Color(white: 0.2))
            
            // Full Content
            Text(right.content)
                .font(.caption)
                .foregroundStyle(Color(white: 0.6))
                .lineSpacing(4)
            
            // Legal Citation
            HStack {
                Image(systemName: "text.book.closed.fill")
                    .font(.caption2)
                Text(right.legalBasis)
                    .font(.caption2.bold())
            }
            .foregroundStyle(Color.blue.opacity(0.8))
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color(white: 0.12))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        // Side colored border indicating priority
        .overlay(
            HStack {
                Rectangle()
                    .fill(right.priority.color)
                    .frame(width: 4)
                Spacer()
            }
        )
        .shadow(color: .black.opacity(0.3), radius: 5, y: 2)
    }
}

struct QuickPhraseCard: View {
    let phrase: QuickPhrase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Situation Label
            HStack {
                Image(systemName: "eye.fill")
                    .font(.caption)
                Text("SITUATION: \(phrase.situation.uppercased())")
                    .font(.caption)
                    .fontWeight(.heavy)
                    .tracking(1)
            }
            .foregroundStyle(Color.orange)
            
            // The Phrase (Hero Text)
            Text("\"\(phrase.phrase)\"")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            
            // Explanation
            Text(phrase.explanation)
                .font(.caption)
                .italic()
                .foregroundStyle(Color(white: 0.5))
        }
        .padding(20)
        .background(Color(white: 0.12))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

// Custom Tab Button Component
struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isSelected ? Color(white: 0.2) : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    NavigationStack {
        ScenarioDetailView(scenario: ContentLoader.shared.scenarios[0])
    }
    .preferredColorScheme(.dark)
}
