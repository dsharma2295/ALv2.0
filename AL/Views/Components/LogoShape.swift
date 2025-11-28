import SwiftUI

struct GuardianShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Geometric Parameters for a "Soft Chevron"
        let width = rect.width
        let height = rect.height
        let thickness = width * 0.28
        
        // Points
        let startLeft = CGPoint(x: width * 0.15, y: height * 0.85)
        let peak = CGPoint(x: width * 0.5, y: height * 0.15)
        let startRight = CGPoint(x: width * 0.85, y: height * 0.85)
        
        // Draw the path (an inverted V)
        path.move(to: startLeft)
        path.addLine(to: peak)
        path.addLine(to: startRight)
        
        // Stroke style creates the thickness and rounded corners automatically
        return path.strokedPath(StrokeStyle(lineWidth: thickness, lineCap: .round, lineJoin: .round))
    }
}
