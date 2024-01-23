import SwiftUI

final class DIContainer {
    
    static let shared = DIContainer()
    
    private init() {}
    
    private let ids: [Int] = Array(1...3)
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    func creatImageCacheService() -> ImageCacheService {
        return ImageCacheService()
    }
    
    func creatNetworkManager() -> NetworkManager {
        return NetworkManager()
    }
    
    @MainActor 
    func creatHomeViewModel() -> HomeViewModel {
        return HomeViewModel(imageCacheService: creatImageCacheService(), 
                             networkManager: creatNetworkManager(),
                             ids: ids)
    }
}
