import Foundation

final class NetworkDataFetch {

    static func getData(_ id: Int) async throws -> ImageDetails {
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
