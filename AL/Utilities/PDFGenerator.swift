import SwiftUI
import PDFKit

struct PDFGenerator {
    static func generateReport(for incident: Incident) -> URL? {
        let htmlContent = createHTML(for: incident)
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // Standard A4
        
        let pdfData = renderer.pdfData { context in
            context.beginPage()
            let attributedString = try? NSAttributedString(
                data: htmlContent.data(using: .utf8)!,
                options: [.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil
            )
            attributedString?.draw(in: CGRect(x: 20, y: 20, width: 572, height: 752))
        }
        
        let fileName = "Incident_Report_\(incident.date.timeIntervalSince1970).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try pdfData.write(to: url)
            return url
        } catch {
            print("Failed to create PDF: \(error)")
            return nil
        }
    }
    
    private static func createHTML(for incident: Incident) -> String {
        // Basic HTML template
        return """
        <html>
        <head>
            <style>
                body { font-family: Helvetica, sans-serif; padding: 40px; }
                h1 { color: #333; }
                .section { margin-bottom: 20px; }
                .label { font-weight: bold; color: #666; font-size: 12px; }
                .content { font-size: 16px; margin-top: 5px; }
            </style>
        </head>
        <body>
            <h1>Incident Report</h1>
            <hr>
            
            <div class="section">
                <div class="label">TITLE</div>
                <div class="content">\(incident.title)</div>
            </div>
            
            <div class="section">
                <div class="label">DATE & TIME</div>
                <div class="content">\(incident.date.formatted(date: .long, time: .standard))</div>
            </div>
            
            <div class="section">
                <div class="label">LOCATION</div>
                <div class="content">\(incident.location)</div>
            </div>
            
            <div class="section">
                <div class="label">AGENCY / OFFICER</div>
                <div class="content">\(incident.agency) - \(incident.officerInfo)</div>
            </div>
            
            <div class="section">
                <div class="label">NOTES</div>
                <div class="content">\(incident.notes)</div>
            </div>
            
            <div class="section">
                <div class="label">EVIDENCE</div>
                <div class="content">Attached Recordings: \(incident.recordings.count)</div>
            </div>
        </body>
        </html>
        """
    }
}
