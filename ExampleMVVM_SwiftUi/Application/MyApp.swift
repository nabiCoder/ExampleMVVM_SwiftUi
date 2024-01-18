import SwiftUI

@main
struct MyApp: App {
    
    private let diContainer = DIContainer.shared
    private let columns: [GridItem]
    private let homeViewModel: HomeViewModel
    
    init() {
        columns = diContainer.columns
        homeViewModel = diContainer.provideHomeViewModel()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: homeViewModel, columns: columns)
        }
    }
}
