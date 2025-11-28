import SwiftUI

struct SplashScreenView: View {
    @State private var isVisible = false
    @State private var shimmer = false
    
    var body: some View {
        ZStack {
            // 1. Clean Void Background
            Color(red: 0.05, green: 0.05, blue: 0.07).ignoresSafeArea()
            
            // 2. Center Logo
            LogoView()
                .scaleEffect(isVisible ? 1.0 : 0.9)
                .opacity(isVisible ? 1.0 : 0.0)
                .blur(radius: isVisible ? 0 : 5)
        }
        .onAppear {
            // Sophisticated Entrance
            withAnimation(.spring(response: 0.9, dampingFraction: 0.5)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}
