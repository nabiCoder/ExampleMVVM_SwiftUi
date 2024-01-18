import Foundation
import SDWebImage

// MARK: - Protocols

protocol ImageCaching: AnyObject {
    func loadImage(with id: Int) async throws -> UIImage
}

protocol ImageCachable {
    func loadCachedImage(forKey key: String) -> UIImage?
    func storeImage(_ image: UIImage, forKey key: String)
}

protocol ImageFetcher {
    func fetchImage(id: Int) async throws -> UIImage
}

// MARK: - ImageCacheService class

final class ImageCacheService {
    
    private let userDefaults = UserDefaults.standard
    private let lastUpdateKey = "LastUpdate"
    private let updateInterval: TimeInterval = 60
}

// MARK: - LoadImage method

extension ImageCacheService: ImageCaching {
    func loadImage(with id: Int) async throws -> UIImage {
        let key = String(id)
        
        guard let lastUpdateDate = userDefaults.object(forKey: lastUpdateKey) as? Date,
              Date().timeIntervalSince(lastUpdateDate) < updateInterval,
              let cachedImage = loadCachedImage(forKey: key) else {
            
            return try await fetchImage(id: id)
        }
        
        return cachedImage
    }
}

// MARK: - LoadCachedImage, StoreImage methods

extension ImageCacheService: ImageCachable {
    func loadCachedImage(forKey key: String) -> UIImage? {
        return SDImageCache.shared.imageFromDiskCache(forKey: key)
    }
    
    func storeImage(_ image: UIImage, forKey key: String) {
        SDImageCache.shared.store(image, forKey: key, toDisk: true)
    }
}

// MARK: - FetchImage method

extension ImageCacheService: ImageFetcher {
    func fetchImage(id: Int) async throws -> UIImage {
        do {
            let imageData = try await NetworkDataFetch.getData(id: id)
            return try await downloadAndCacheImage(image: imageData, key: id)
        } catch {
            throw NetworkError.urlError
        }
    }
}

// MARK: - DownloadAndCacheImage method

private extension ImageCacheService {
    func downloadAndCacheImage(image: ImageDetails, key: Int) async throws -> UIImage {
        guard let imageURL = URL(string: image.url) else {
            throw NetworkError.canNotParseData
        }
        
        do {
            
            let downloadedImage = try await withCheckedThrowingContinuation { continuation in
                SDWebImageManager.shared.loadImage(
                    with: imageURL,
                    options: .highPriority,
                    context: nil,
                    progress: { receivedSize, expectedSize, _ in
                        // Handle progress if needed
                    },
                    completed: { image, _, _, _, _, _ in
                        if let downloadedImage = image {
                            self.storeImage(downloadedImage, forKey: String(key))
                            self.userDefaults.set(Date(), forKey: self.lastUpdateKey)
                            
                            continuation.resume(returning: downloadedImage)
                        } else {
                            continuation.resume(throwing: NetworkError.errorDownloadingImage)
                        }
                    }
                )
            }
            
            return downloadedImage
            
        } catch {
            throw NetworkError.errorDownloadingImage
        }
    }
}
