import ComposableArchitecture
import SwiftUI

struct MySpaceView: View {
    let store: StoreOf<MySpaceFeature>

    var body: some View {
        VStack(spacing: 0) {
            CMCNavigationBar(title: "라이브러리", trailing: {
                Button {} label: {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.CMC.textPrimary)
                }
                .buttonStyle(.plain)
            })
            Divider().background(Color.CMC.separator)
            CMCScrollTabView()
            Spacer()
        }
        .onAppear { store.send(.onAppear) }
    }
}

#Preview {
    MySpaceView(store: Store(initialState: MySpaceFeature.State()) { MySpaceFeature() })
}
