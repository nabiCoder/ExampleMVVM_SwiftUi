import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ProgressView()
            .scaleEffect(2.0, anchor: .center)
    }
}
