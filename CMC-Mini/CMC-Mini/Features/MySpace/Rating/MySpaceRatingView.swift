import ComposableArchitecture
import SwiftUI

struct MySpaceRatingView: View {
    let store: StoreOf<MySpaceRatingFeature>

    var body: some View {
        Text(CMCContentTab.rating.rawValue)
            .font(Font.CMC.body)
            .foregroundStyle(Color.CMC.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    MySpaceRatingView(
        store: Store(initialState: MySpaceRatingFeature.State()) {
            MySpaceRatingFeature()
        }
    )
}
