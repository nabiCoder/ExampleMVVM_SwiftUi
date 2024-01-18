import SwiftUI

struct ImageGrid: View {
    
    let columns: [GridItem]
    let images: [UIImage]?
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(images ?? [], id: \.self) { image in
                NavigationLink(destination: DetailView(image: image)) {
                    ResizableView(image: image)
                }
            }
        }
    }
}
