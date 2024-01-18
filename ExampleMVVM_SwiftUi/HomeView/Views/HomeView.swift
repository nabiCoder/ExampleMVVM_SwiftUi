import SwiftUI

struct HomeView: View {
    
    @ObservedObject var viewModel = HomeViewModel()
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
    var body: some View {
        NavigationStack {
            ContentView(viewModel: viewModel, columns: columns)
        }
    }
}
