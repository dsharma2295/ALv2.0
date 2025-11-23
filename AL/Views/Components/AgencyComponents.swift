import SwiftUI

// MARK: - Location Card (Used in LocationsView)
struct LocationCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let gradient: LinearGradient
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                // Icon with glow
                Image(systemName: icon)
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
                    .shadow(color: .white.opacity(0.5), radius: 10)
                    .padding(.bottom, 8)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .shadow(radius: 2)
                
                Text(subtitle)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white.opacity(0.7))
                    .textCase(.uppercase)
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white.opacity(0.3))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(gradient.opacity(0.3)) // Tint the glass slightly
        .glass(cornerRadius: 24)
    }
}

// MARK: - List Card (Used in AgencyHub)
struct ListCardView: View {
    let card: ContentCard
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(card.title)
                    .font(.headline)
                    .engraved()
                
                Spacer()
                
                if card.priority == .critical {
                    Label("CRITICAL", systemImage: "exclamationmark.triangle.fill")
                        .font(.system(size: 10, weight: .black))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.8))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            
            Text(card.summary)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.white)
            
            Divider().background(Color.white.opacity(0.1))
            
            Text(card.detail)
                .font(.caption)
                .foregroundStyle(Color.gray)
                .lineLimit(3)
        }
        .padding()
        .glass(cornerRadius: 16)
    }
}

// MARK: - Focus Card (Used in Carousel)
struct FocusCardView: View {
    let card: ContentCard
    let color: Color
    @Environment(\.openURL) var openURL
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header
            HStack {
                Text(card.priority.rawValue.uppercased())
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(8)
                    .background(card.priority.color.opacity(0.2))
                    .foregroundStyle(card.priority.color)
                    .clipShape(Capsule())
                Spacer()
            }
            
            Text(card.title)
                .font(.system(size: 34, weight: .heavy))
                .foregroundStyle(.white)
                .engraved()
            
            Text(card.summary)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundStyle(Color(white: 0.9))
            
            Divider().overlay(Color.white.opacity(0.2))
            
            ScrollView {
                Text(card.detail)
                    .font(.body)
                    .lineSpacing(6)
                    .foregroundStyle(.gray)
                
                if !card.legalBasis.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("LEGAL BASIS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(white: 0.4))
                            .padding(.top, 20)
                        
                        HStack {
                            Image(systemName: "text.book.closed.fill")
                            Text(card.legalBasis)
                        }
                        .font(.subheadline)
                        .foregroundStyle(Color.blue)
                        .onTapGesture {
                            if let urlString = card.sourceURL, let url = URL(string: urlString) {
                                openURL(url)
                            }
                        }
                    }
                }
            }
        }
        .padding(32)
        .frame(height: 520)
        .glass(cornerRadius: 30)
    }
}

// MARK: - Phrase View
struct PhraseView: View {
    let phrase: QuickPhrase
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SITUATION: \(phrase.situation)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.orange)
            
            Text("\"\(phrase.phrase)\"")
                .font(.title3)
                .italic()
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
            
            Text(phrase.explanation)
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding()
        .glass(cornerRadius: 12)
    }
}
