import SwiftUI

// MARK: - Enums & Helpers
enum ContentType: String, Identifiable, CaseIterable {
    case rights = "Rights"
    case canDo = "Can Do"
    case cannotDo = "Cannot Do"
    case phrases = "Phrases"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .rights: return .blue
        case .canDo: return .green
        case .cannotDo: return .red
        case .phrases: return .orange
        }
    }
}

struct AgencyHubView: View {
    let agency: Agency
    @State private var selectedTab: ContentType = .rights
    @State private var isFocusMode: Bool = false
    @State private var showInfoModal: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 1. Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(ContentType.allCases) { type in
                            Button(action: {
                                withAnimation(.snappy) { selectedTab = type }
                            }) {
                                Text(type.rawValue)
                                    .font(.system(size: 13, weight: .bold))
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 16)
                                    .background(
                                        selectedTab == type ?
                                        type.color.gradient :
                                            Color.clear.gradient
                                    )
                                    .background(selectedTab == type ? Color.clear : Color(white: 0.1))
                                    .foregroundStyle(.white)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule().stroke(selectedTab == type ? .white.opacity(0.3) : .white.opacity(0.1), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                
                // 2. View Toggle
                if selectedTab != .phrases {
                    HStack {
                        Spacer()
                        Picker("Mode", selection: $isFocusMode) {
                            Image(systemName: "list.bullet").tag(false)
                            Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill").tag(true)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 100)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                // 3. Content Area
                TabView(selection: $selectedTab) {
                    ContentViewHelper(cards: agency.rights, mode: isFocusMode, color: .blue).tag(ContentType.rights)
                    ContentViewHelper(cards: agency.canDo, mode: isFocusMode, color: .green).tag(ContentType.canDo)
                    ContentViewHelper(cards: agency.cannotDo, mode: isFocusMode, color: .red).tag(ContentType.cannotDo)
                    PhrasesListView(phrases: agency.quickPhrases).tag(ContentType.phrases)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            
            // 4. Floating Info Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: { showInfoModal = true }) {
                        Image(systemName: "info")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 50, height: 50)
                            .background(Color.blue.gradient)
                            .clipShape(Circle())
                            .shadow(color: .blue.opacity(0.5), radius: 8, y: 4)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(agency.shortName)
        .navigationBarTitleDisplayMode(.large)
        .sheet(isPresented: $showInfoModal) {
            AgencyInfoSheet(agency: agency) // Fixed Name
                .presentationDetents([.fraction(0.4)])
                .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Helper Views
struct ContentViewHelper: View {
    let cards: [ContentCard]
    let mode: Bool // false = list, true = focus
    let color: Color
    
    var body: some View {
        if mode {
            // Focus Mode (Carousel)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(cards) { card in
                        FocusCardView(card: card, color: color)
                            .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(20, for: .scrollContent)
        } else {
            // List Mode
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cards) { card in
                        ListCardView(card: card, color: color)
                    }
                }
                .padding()
            }
        }
    }
}

struct PhrasesListView: View {
    let phrases: [QuickPhrase]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(phrases) { phrase in
                    PhraseView(phrase: phrase)
                }
            }
            .padding()
        }
    }
}

struct AgencyInfoSheet: View {
    let agency: Agency
    @Environment(\.openURL) var openURL
    
    var body: some View {
        ZStack {
            Color(white: 0.15).ignoresSafeArea()
            VStack(spacing: 20) {
                Text(agency.name)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top)
                
                Text(agency.about)
                    .font(.body)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Button("Visit Official Website") {
                    if let url = URL(string: agency.websiteURL) {
                        openURL(url)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
