import Foundation

struct EndPoint {
    var id: Int
}

extension EndPoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "jsonplaceholder.typicode.com"
        components.path = "/photos/\(id)"
        
        guard let url = components.url else {
            fatalError("Failed to create URL")
        }
        
        return url
    }
}

extension EndPoint {
    static func image(id: Int) -> Self {
        EndPoint(id: id)
    }
}
