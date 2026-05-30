import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
    let store: StoreOf<ProfileFeature>

    var body: some View {
        VStack(spacing: 0) {
            CMCNavigationBar(title: "프로필")
            Divider().background(Color.CMC.separator)
            Spacer()
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    ProfileView(store: Store(initialState: ProfileFeature.State()) { ProfileFeature() })
}
