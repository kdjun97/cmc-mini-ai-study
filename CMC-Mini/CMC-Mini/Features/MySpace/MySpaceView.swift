import ComposableArchitecture
import SwiftUI

struct MySpaceView: View {
    @Bindable var store: StoreOf<MySpaceFeature>

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

            CMCScrollTabView(selectedTab: $store.selectedContentTab)

            Divider().background(Color.CMC.separator)

            tabContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { store.send(.onAppear) }
    }

    @ViewBuilder
    private var tabContent: some View {
        switch store.selectedContentTab {
        case .wishlist:
            MySpaceWishlistView(
                store: store.scope(state: \.wishlistState, action: \.wishlistAction)
            )
        case .calendar:
            MySpaceCalendarView(
                store: store.scope(state: \.calendarState, action: \.calendarAction)
            )
        case .rating:
            MySpaceRatingView(
                store: store.scope(state: \.ratingState, action: \.ratingAction)
            )
        case .timeline:
            MySpaceTimelineView(
                store: store.scope(state: \.timelineState, action: \.timelineAction)
            )
        case .gallery:
            MySpaceGalleryView(
                store: store.scope(state: \.galleryState, action: \.galleryAction)
            )
        }
    }
}

#Preview {
    MySpaceView(store: Store(initialState: MySpaceFeature.State()) { MySpaceFeature() })
}
