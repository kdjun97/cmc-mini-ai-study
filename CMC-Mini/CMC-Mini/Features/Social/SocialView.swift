import ComposableArchitecture
import SwiftUI

struct SocialView: View {
    let store: StoreOf<SocialFeature>

    var body: some View {
        VStack(spacing: 0) {
            CMCNavigationBar(title: "소셜")
            Divider().background(Color.CMC.separator)
            Spacer()
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    SocialView(store: Store(initialState: SocialFeature.State()) { SocialFeature() })
}
