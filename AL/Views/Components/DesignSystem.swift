import SwiftUI

// MARK: - 1. The "Aurora" Animated Background
struct AuroraBackground: View {
    @State private var start = UnitPoint(x: 0, y: -2)
    @State private var end = UnitPoint(x: 4, y: 0)
    
    let colors: [Color] = [
        Color(red: 0.1, green: 0.1, blue: 0.2), // Deep Midnight
        Color(red: 0.2, green: 0.2, blue: 0.3), // Soft Gray-Blue
        Color.black,                            // Anchor Black
        Color(red: 0.05, green: 0.2, blue: 0.4).opacity(0.6) // Subtle Blue Glow
    ]
    
    var body: some View {
        LinearGradient(colors: colors, startPoint: start, endPoint: end)
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 10).repeatForever(autoreverses: true)) {
                    start = UnitPoint(x: 4, y: 0)
                    end = UnitPoint(x: 0, y: 2)
                }
            }
            .overlay(
                Rectangle()
                    .fill(.white.opacity(0.02))
                    .blendMode(.overlay)
            )
    }
}

// MARK: - 2. The "Glass" Modifier
struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1)
            )
    }
}

// MARK: - 3. Bouncy Button Style (THIS FIXES YOUR ERROR)
struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - 4. Engraved Text Style
struct EngravedTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(white: 0.9))
            .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1)
    }
}

// MARK: - 5. Extensions
extension View {
    func glass(cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassModifier(cornerRadius: cornerRadius))
    }
    
    // Backward compatibility alias
    func metallic(cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassModifier(cornerRadius: cornerRadius))
    }
    
    func engraved() -> some View {
        modifier(EngravedTextStyle())
    }
}
