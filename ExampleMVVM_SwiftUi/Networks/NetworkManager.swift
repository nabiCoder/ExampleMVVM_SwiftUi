import Foundation
import UIKit

final class NetworkManager {
    
    private var imageUrl: String?
    
    init() {}
    
    var image: UIImage? {
        get async throws {
            guard let url = URL(string: imageUrl ?? "") else { return nil}
            let (data, _) = try await URLSession.shared.data(from: url)
            
            return UIImage(data: data)
        }
    }
    
    func setData(imageUrl: String) {
        self.imageUrl = imageUrl
    }
    
    func getData(_ id: Int) async throws -> ImageDetails {
        let decoder = JSONDecoder()
        do {
            let response = try await URLSession.shared.request(.image(id: id))
            let result = try decoder.decode(ImageDetails.self, from: response.0)
            
            return result
        } catch {
            throw error
        }
    }
}
