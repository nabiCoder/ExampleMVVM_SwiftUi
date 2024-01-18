import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    private var columns: [GridItem]
    
    init(viewModel: HomeViewModel, columns: [GridItem]) {
        self.viewModel = viewModel
        self.columns = columns
    }
    
    var body: some View {
        NavigationStack {
            ContentView(viewModel: viewModel, columns: columns)
        }
    }
}
