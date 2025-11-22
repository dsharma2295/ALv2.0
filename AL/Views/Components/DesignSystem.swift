//
//  DesignSystem.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import SwiftUI

// --- 1. The Metallic Surface Modifier ---
// Applies the dark, brushed metal look with a bevel and drop shadow.
struct MetallicSurface: ViewModifier {
    var cornerRadius: CGFloat = 24
    
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.15, green: 0.15, blue: 0.16), // Top (Lighter)
                        Color(red: 0.10, green: 0.10, blue: 0.11)  // Bottom (Darker)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .shadow(color: .black.opacity(0.6), radius: 10, x: 0, y: 5) // Deep Drop Shadow
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.15), .black.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    ) // Beveled Edge
            )
    }
}

// --- 2. The Engraved Text Modifier ---
// Makes text look stamped into the metal.
struct EngravedTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundStyle(Color(white: 0.9))
            .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 1) // Inner shadow effect
    }
}

// --- 3. The Physics Button Style ---
// Makes buttons scale down satisfyingly when pressed.
struct BouncyButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// --- Extensions for easy access ---
extension View {
    func metallic(cornerRadius: CGFloat = 24) -> some View {
        modifier(MetallicSurface(cornerRadius: cornerRadius))
    }
    
    func engraved() -> some View {
        modifier(EngravedTextStyle())
    }
}
