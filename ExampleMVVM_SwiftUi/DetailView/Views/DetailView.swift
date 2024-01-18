import SwiftUI

struct DetailView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Resources.ViewTitles.detail, displayMode: .inline)
    }
}

private extension DetailView {
    
}
