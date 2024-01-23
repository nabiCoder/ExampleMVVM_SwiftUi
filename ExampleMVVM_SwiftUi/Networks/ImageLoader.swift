import Foundation
import UIKit

final class ImageLoader {
    private let imageUrl: String
    
    init(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    var image: UIImage? {
        get async throws {
            guard let url = URL(string: imageUrl) else { return nil}
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return UIImage(data: data)
        }
    }
}
