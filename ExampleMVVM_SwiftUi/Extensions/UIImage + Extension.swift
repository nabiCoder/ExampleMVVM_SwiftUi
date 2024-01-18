import UIKit

extension UIImage {
    var uniqueHash: Int {
        return self.pngData()?.hashValue ?? 0
    }
}
