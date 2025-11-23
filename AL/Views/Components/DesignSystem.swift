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
                // Noise texture for that "premium" matte finish
                Rectangle()
                    .fill(.white.opacity(0.02))
                    .blendMode(.overlay)
            )
    }
}

// MARK: - 2. The "Glass" Modifier (The Native Feel)
// Replaces "MetallicSurface" with true iOS blurred glass
struct GlassModifier: ViewModifier {
    var cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial) // The Magic: Native iOS Blur
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10) // Soft Shadow
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.white.opacity(0.1), lineWidth: 1) // Subtle frost border
            )
    }
}

// MARK: - 3. Typography & Button Styles
extension View {
    func glass(cornerRadius: CGFloat = 24) -> some View {
        modifier(GlassModifier(cornerRadius: cornerRadius))
    }
    
    func engraved() -> some View {
        self.foregroundStyle(.white)
            .shadow(color: .black.opacity(0.5), radius: 1, x: 0, y: 1)
    }
}
