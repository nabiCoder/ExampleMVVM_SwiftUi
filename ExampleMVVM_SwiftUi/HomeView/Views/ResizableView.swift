import SwiftUI

struct ResizableView: View {
    
    let image: UIImage
    
    var body: some View {
        displayResizedImage(uiImage: image)
    }
}

private extension ResizableView {
    
    func displayResizedImage(uiImage: UIImage) -> some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 150, height: 150)
            .aspectRatio(contentMode: .fill)
    }
}
