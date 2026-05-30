import ComposableArchitecture
import SwiftUI

struct MySpaceGalleryView: View {
    let store: StoreOf<MySpaceGalleryFeature>

    var body: some View {
        Text(CMCContentTab.gallery.rawValue)
            .font(Font.CMC.body)
            .foregroundStyle(Color.CMC.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    MySpaceGalleryView(
        store: Store(initialState: MySpaceGalleryFeature.State()) {
            MySpaceGalleryFeature()
        }
    )
}
