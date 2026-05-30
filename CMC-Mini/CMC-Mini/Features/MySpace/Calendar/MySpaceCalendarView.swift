import ComposableArchitecture
import SwiftUI

struct MySpaceCalendarView: View {
    let store: StoreOf<MySpaceCalendarFeature>

    var body: some View {
        CMCCalendarView { action in
            switch action {
            case .aspectRatio:
                store.send(.aspectRatioTapped)
            case .favorite:
                store.send(.favoriteTapped)
            case .share:
                store.send(.shareTapped)
            case .settings:
                store.send(.settingsTapped)
            }
        }
    }
}

#Preview {
    MySpaceCalendarView(
        store: Store(initialState: MySpaceCalendarFeature.State()) {
            MySpaceCalendarFeature()
        }
    )
}
