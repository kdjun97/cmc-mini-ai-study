import ComposableArchitecture
import SwiftUI

struct SearchView: View {
    let store: StoreOf<SearchFeature>

    var body: some View {
        VStack(spacing: 0) {
            CMCNavigationBar(title: "검색")
            Divider().background(Color.CMC.separator)
            Spacer()
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    SearchView(store: Store(initialState: SearchFeature.State()) { SearchFeature() })
}
