import Foundation
import UIKit

protocol ImageLoadable {
    func loadImagesFromCache(_ ids: [Int]) async throws -> [UIImage]
}

protocol ImageDetailsFetchable {
    func fetchImageDetails() async
}

// MARK: - HomeViewModel Class

@MainActor
final class HomeViewModel: ObservableObject {
    
    private var imageCacheService: ImageCacheService
    private let ids: [Int]
    
    @Published var dataSource: [UIImage]?
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMassage: String?
    
    init(imageCacheService: ImageCacheService, ids: [Int]) {
        self.imageCacheService = imageCacheService
        self.ids = ids
    }
}

// MARK: - ImageDetailsFetchable Extension

extension HomeViewModel: ImageDetailsFetchable {
    
    func fetchImageDetails() async {
        isLoading = true
        do {
            let imageData = try await loadImagesFromCache(ids)
            
            self.dataSource = imageData
            self.isLoading = false
        } catch(let error) {
            self.isLoading = false
            self.isError = true
            self.errorMassage = error.localizedDescription
        }
    }
}

// MARK: - ImageLoadable Extension

extension HomeViewModel: ImageLoadable {
    
    func loadImagesFromCache(_ ids: [Int]) async throws -> [UIImage] {
        var images = [UIImage]()
        
        try await withThrowingTaskGroup(of: UIImage.self) { group in
            for id in ids {
                group.addTask {
                    return try await self.imageCacheService.loadImage(with: id)
                }
            }
            
            for try await image in group {
                images.append(image)
            }
        }
        return images
    }
}
