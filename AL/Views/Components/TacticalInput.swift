//
//  TacticalInput.swift
//  AL
//
//  Created by Divyanshu Sharma on 11/20/25.
//
import SwiftUI

struct TacticalInput: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    var icon: String
    var isMultiLine: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(.gray)
                Text(title.uppercased())
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(.gray)
                    .tracking(1)
            }
            .padding(.leading, 4)
            
            // Input Field
            ZStack(alignment: .topLeading) {
                if isMultiLine {
                    TextEditor(text: $text)
                        .frame(minHeight: 100)
                        .scrollContentBackground(.hidden) // Removes default gray background
                        .foregroundStyle(.white)
                        .padding(12)
                } else {
                    TextField(placeholder, text: $text)
                        .foregroundStyle(.white)
                        .padding(16)
                }
            }
            .background(Color(white: 0.12))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.white.opacity(0.08), lineWidth: 1)
            )
            // Inner Shadow Effect (simulating recessed screen)
            .shadow(color: .white.opacity(0.05), radius: 1, x: 0, y: 1)
        }
    }
}
