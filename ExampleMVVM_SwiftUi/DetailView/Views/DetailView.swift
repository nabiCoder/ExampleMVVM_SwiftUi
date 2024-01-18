import SwiftUI

struct DetailView: View {
    let image: UIImage
    
    var body: some View {
        displayImageDetail(uiImage: image)
    }
}

private extension DetailView {
    
    func displayImageDetail(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Resources.ViewTitles.detail, displayMode: .inline)
    }
}
