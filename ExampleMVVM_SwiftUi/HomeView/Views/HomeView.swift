import SwiftUI

struct HomeView: View {
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.dataSource ?? [], id: \.id) { url in
                        AsyncImage(url: URL(string: url.url)) { result in
                            switch result {
                            case .empty:
                                Text("Image not available")
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .aspectRatio(contentMode: .fill)
                            case .failure(let error):
                                Text("Failed to load image: \(error.localizedDescription)")
                                
//                            @unknown default:
//                                Text("Failed to load image")
                        
                                
                            }
                        }
                    }
                }
                .task {
                    await viewModel.fetchImageDetails()
                }
            }
        }
    }
}


#Preview {
    HomeView()
}
