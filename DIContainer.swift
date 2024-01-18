import SwiftUI

final class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    private let ids: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    func provideImageCacheService() -> ImageCacheService {
        return ImageCacheService()
    }
    
    @MainActor 
    func provideHomeViewModel() -> HomeViewModel {
        return HomeViewModel(imageCacheService: provideImageCacheService(), ids: ids)
    }
}
