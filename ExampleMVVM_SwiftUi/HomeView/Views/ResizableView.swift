import SwiftUI

struct ResizableView: View {
    
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 150, height: 150)
            .aspectRatio(contentMode: .fill)
    }
}
