import Foundation

extension URLSession {
    
    typealias Response = (Data, URLResponse)
    
    @discardableResult
    
    func request(_ endPoint: EndPoint) async throws -> Response {
        do {
            let response = try await data(from: endPoint.url)
            
            return response
        } catch {
            throw NetworkError.errorDownloadingImage
        }
    }
}
