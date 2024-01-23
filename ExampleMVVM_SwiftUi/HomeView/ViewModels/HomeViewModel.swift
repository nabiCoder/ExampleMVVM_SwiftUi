import Foundation
import SwiftUI

protocol ImageLoadable {
    func loadImageFromCacheOrNetwork(_ ids: [Int]) async throws -> [UIImage]
}

protocol ImageDetailsFetchable {
    func fetchImageDetailsIfNeeded() async
}

// MARK: - HomeViewModel Class

@MainActor
final class HomeViewModel: ObservableObject {
    
    private let imageCacheService: ImageCacheService
    private let networkManager: NetworkManager
    private let ids: [Int]
    private let placeholderImage = Resources.Images.noImage
    
    @Published var dataSource: [UIImage]?
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMassage: String?
    @Published var hasLoadedData = false
    
    init(imageCacheService: ImageCacheService, networkManager: NetworkManager, ids: [Int]) {
        self.imageCacheService = imageCacheService
        self.networkManager = networkManager
        self.ids = ids
    }
}

// MARK: - ImageDetailsFetchable Extension

extension HomeViewModel: ImageDetailsFetchable {
    
    func fetchImageDetailsIfNeeded() async {
        guard !hasLoadedData else { return }
        isLoading = true
        Task {
            do {
                let imageData = try await loadImageFromCacheOrNetwork(ids)
                self.dataSource = imageData
                self.isLoading = false
                self.hasLoadedData = true
            } catch(let error) {
                handleImageDetailsFetchError(error)
            }
        }
    }
}

// MARK: - ImageLoadable Extension

extension HomeViewModel: ImageLoadable {
    
    func loadImageFromCacheOrNetwork(_ ids: [Int]) async throws -> [UIImage] {
        var images = [UIImage]()
        
        try await withThrowingTaskGroup(of: UIImage.self) { group in
            for id in ids {
                group.addTask {
                    let loadedImage = try await self.loadImage(id)
                    self.imageCacheService.saveImageToCache(loadedImage, forKey: String(id))
                    return loadedImage
                }
            }
            
            for try await image in group {
                images.append(image)
            }
        }
        return images
    }
    
    private func loadImage(_ id: Int) async throws -> UIImage {
        do {
            if let cachedImage =  try await imageCacheService.getCachedImage(id) {
                return cachedImage
            } else {
                let networkResultData = try await networkManager.getData(id)
                let imageUrl = networkResultData.url
                
                let _ = networkManager.setData(imageUrl: imageUrl)
                let loadedImage = try await networkManager.image
                
                return loadedImage ?? defaultPlaceholderImage()
            }
        } catch NetworkError.errorDownloadingImage {
            return UIImage(named: placeholderImage) ?? UIImage()
            
        } catch NetworkError.noInternetConnection {
            return UIImage(named: placeholderImage) ?? UIImage()
            
        } catch {
            throw error
        }
    }
    
    private func defaultPlaceholderImage() -> UIImage {
        return UIImage(named: placeholderImage) ?? UIImage()
    }
    
    private func handleImageDetailsFetchError(_ error: Error) {
        self.isLoading = false
        self.isError = true
        self.errorMassage = error.localizedDescription
    }
}
