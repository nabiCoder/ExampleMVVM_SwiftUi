import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    let columns: [GridItem]
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ScrollView(.vertical) {
                ImageGrid(columns: columns, images: viewModel.dataSource)
                    .navigationTitle(Resources.ViewTitles.home)
            }
            .task {
                await viewModel.fetchImageDetails()
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
    }
}
