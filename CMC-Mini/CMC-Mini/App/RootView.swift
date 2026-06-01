import ComposableArchitecture
import SwiftUI

struct RootView: View {
    @Bindable var store: StoreOf<RootFeature>

    var body: some View {
        VStack(spacing: 0) {
            tabContent
            CMCTabBar(
                selectedTab: $store.selectedTab,
                onAddTap: {}
            )
        }
        .background(Color.CMC.background)
        .ignoresSafeArea(edges: .bottom)
    }

    @ViewBuilder
    private var tabContent: some View {
        switch store.selectedTab {
        case .social:
            SocialView(store: store.scope(state: \.socialState, action: \.socialAction))
        case .search:
            SearchView(store: store.scope(state: \.searchState, action: \.searchAction))
        case .mySpace:
            MySpaceView(store: store.scope(state: \.mySpaceState, action: \.mySpaceAction))
        case .profile:
            ProfileView(store: store.scope(state: \.profileState, action: \.profileAction))
        }
    }
}

#Preview {
    RootView(
        store: Store(initialState: RootFeature.State()) {
            RootFeature()
        }
    )
}
