import ComposableArchitecture
import SwiftUI

struct MySpaceWishlistView: View {
    let store: StoreOf<MySpaceWishlistFeature>

    var body: some View {
        Text(CMCContentTab.wishlist.rawValue)
            .font(Font.CMC.body)
            .foregroundStyle(Color.CMC.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    MySpaceWishlistView(
        store: Store(initialState: MySpaceWishlistFeature.State()) {
            MySpaceWishlistFeature()
        }
    )
}
