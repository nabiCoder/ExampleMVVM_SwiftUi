import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var dataSource: [ImageDetails]?
    @Published var isLoading = false
    @Published var isError = false
    @Published var errorMassage: String?
    
    func fetchImageDetails() async {
        isLoading = true
        do {
            let imageData = try await loadImages([1, 2, 3, 4, 5, 6, 7, 8, 9])
              
            self.dataSource = imageData
            self.isLoading = false
            
        } catch(let error) {
            self.isLoading = false
            self.isError = true
            self.errorMassage = error.localizedDescription
        }
    }
    
    private func loadImages(_ ids: [Int]) async throws -> [ImageDetails] {
        var images = [ImageDetails]()
        
        try await withThrowingTaskGroup(of: ImageDetails.self) { group in
            for id in ids {
                group.addTask {
                    return try await NetworkDataFetch.getData(id: id)
                }
            }
            
            for try await image in group {
                images.append(image)
            }
        }
        return images
    }
}
