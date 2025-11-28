import SwiftUI

struct LogoView: View {
    @State private var shine: Bool = false
    
    // Premium Palette: Deep Electric Blue to Cyan
    let primaryGradient = LinearGradient(
        colors: [
            Color(red: 0.0, green: 0.3, blue: 0.9), // Deep Blue
            Color(red: 0.0, green: 0.7, blue: 1.0)  // Bright Cyan
        ],
        startPoint: .bottomLeading,
        endPoint: .topTrailing
    )
    
    var body: some View {
        VStack(spacing: 40) {
            // THE ICON (Floating, No Background)
            ZStack {
                // 1. Inner Shadow (Depth) for the Shape itself
                GuardianShape()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 100, height: 100) // Kept original size
                    .offset(x: 2, y: 4)
                    .blur(radius: 2)
                
                // 2. Main Gradient Body
                GuardianShape()
                    .fill(primaryGradient)
                    .frame(width: 100, height: 100)
                    // Soft Glow behind the shape to make it pop against black
                    .shadow(color: Color.blue.opacity(0.6), radius: 20, x: 0, y: 0)
                
                // 3. "Glass" Reflection Highlight (Top Edge)
                GuardianShape()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100, height: 100)
            }
            // Explicit frame to maintain spacing where the squircle used to be
            .frame(width: 180, height: 180)
            
            // THE BRAND NAME
            VStack(spacing: 8) {
                Text("AL")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .tracking(2)
                
                Text("LEGAL ASSISTANT")
                    .font(.system(size: 10, weight: .heavy))
                    .foregroundStyle(Color.gray)
                    .tracking(4)
                    .textCase(.uppercase)
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        LogoView()
    }
}
