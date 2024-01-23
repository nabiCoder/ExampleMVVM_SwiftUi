import SwiftUI

struct ImageGrid: View {
    
    let columns: [GridItem]
    let images: [UIImage]?
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(images ?? [], id: \.uniqueHash) { image in
                NavigationLink(destination: DetailView(image: image)) {
                    VStack {
                        ResizableView(image: image)
                    }
                }
                .id(UUID())
            }
        }
    }
}

