import Foundation
import SwiftUI

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
    private let placeholderImage = Resources.Images.noImage
    
    @Published var dataSource: [UIImage]?
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMassage: String?
    @Published var hasLoadedData = false
    
    init(imageCacheService: ImageCacheService, ids: [Int]) {
        self.imageCacheService = imageCacheService
        self.ids = ids
    }
}

// MARK: - ImageDetailsFetchable Extension

extension HomeViewModel: ImageDetailsFetchable {
    
    func fetchImageDetails() async {
        guard !hasLoadedData else { return }
        isLoading = true
        Task {
            do {
                let imageData = try await loadImagesFromCache(ids)
                self.dataSource = imageData
                self.isLoading = false
                self.hasLoadedData = true
            } catch(let error) {
                self.isLoading = false
                self.isError = true
                self.errorMassage = error.localizedDescription
            }
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
                    return try await self.loadImageFromCacheOrNetwork(id)
                }
            }
            
            for try await image in group {
                images.append(image)
            }
        }
        return images
    }
    
    private func loadImageFromCacheOrNetwork(_ id: Int) async throws -> UIImage {
        do {
            if let cachedImage =  try await imageCacheService.getCachedImage(id) {
                return cachedImage
            } else {
                let networkResultData = try await NetworkDataFetch.getData(id)
                let imageUrl = networkResultData.url
                
                let imageLoader = ImageLoader(imageUrl: imageUrl)
                let loadedImage = try await imageLoader.image
                
                return loadedImage ?? UIImage(named: placeholderImage)!
            }
        } catch NetworkError.errorDownloadingImage {
            return UIImage(named: placeholderImage) ?? UIImage()
            
        } catch NetworkError.noInternetConnection {
            return UIImage(named: placeholderImage) ?? UIImage()
            
        } catch {
            throw error
        }
    }
}
