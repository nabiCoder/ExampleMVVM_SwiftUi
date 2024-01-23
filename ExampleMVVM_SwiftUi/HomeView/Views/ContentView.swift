import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    let columns: [GridItem]
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                ImageGrid(columns: columns, images: viewModel.dataSource)
                    .navigationTitle(Resources.ViewTitles.home)
            }
            .onAppear {
                Task {
                    await viewModel.fetchImageDetailsIfNeeded()
                }
            }
            if viewModel.isLoading {
                LoadingView()
            }
        }
        .alert(isPresented: $viewModel.isError) {
            return Alert(title: Text("Error"), message: Text(viewModel.errorMassage ?? ""))
        }
    }
}
