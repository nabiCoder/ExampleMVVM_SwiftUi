import SDWebImage

// MARK: - Protocols

protocol ImageCachable {
    func getCachedImage(_ id: Int) async throws -> UIImage?
    func saveImageToCache(_ image: UIImage, forKey key: String)
}

// MARK: - ImageCacheService class

final class ImageCacheService {
    private let imageCache = SDImageCache.shared
}

// MARK: - LoadCachedImage, StoreImage methods

extension ImageCacheService: ImageCachable {
    func getCachedImage(_ id: Int) async throws -> UIImage? {
        let key = String(id)
        
        if let cashedImage = imageCache.imageFromDiskCache(forKey: key) {
            return cashedImage
        } else {
            return nil
        }
    }
    
    func saveImageToCache(_ image: UIImage,forKey key: String) {
        imageCache.store(image, forKey: key, toDisk: true)
    }
}
