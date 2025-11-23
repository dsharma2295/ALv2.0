import SwiftUI

struct BookmarksView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            AuroraBackground()
            
            VStack {
                Image(systemName: "bookmark.slash")
                    .font(.system(size: 60))
                    .foregroundStyle(.gray)
                    .padding()
                
                Text("No Bookmarks Yet")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                Text("Save rights and phrases for quick access here.")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .navigationTitle("Saved Items")
    }
}
