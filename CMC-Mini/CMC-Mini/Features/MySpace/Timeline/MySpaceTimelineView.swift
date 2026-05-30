import ComposableArchitecture
import SwiftUI

struct MySpaceTimelineView: View {
    let store: StoreOf<MySpaceTimelineFeature>

    var body: some View {
        Text(CMCContentTab.timeline.rawValue)
            .font(Font.CMC.body)
            .foregroundStyle(Color.CMC.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    MySpaceTimelineView(
        store: Store(initialState: MySpaceTimelineFeature.State()) {
            MySpaceTimelineFeature()
        }
    )
}
