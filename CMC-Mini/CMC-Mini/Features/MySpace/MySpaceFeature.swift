import ComposableArchitecture

@Reducer
struct MySpaceFeature {
    @ObservableState
    struct State: Equatable {
        var selectedContentTab: CMCContentTab = .calendar
        var wishlistState: MySpaceWishlistFeature.State = .init()
        var calendarState: MySpaceCalendarFeature.State = .init()
        var ratingState: MySpaceRatingFeature.State = .init()
        var timelineState: MySpaceTimelineFeature.State = .init()
        var galleryState: MySpaceGalleryFeature.State = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case wishlistAction(MySpaceWishlistFeature.Action)
        case calendarAction(MySpaceCalendarFeature.Action)
        case ratingAction(MySpaceRatingFeature.Action)
        case timelineAction(MySpaceTimelineFeature.Action)
        case galleryAction(MySpaceGalleryFeature.Action)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.wishlistState, action: \.wishlistAction) {
            MySpaceWishlistFeature()
        }
        Scope(state: \.calendarState, action: \.calendarAction) {
            MySpaceCalendarFeature()
        }
        Scope(state: \.ratingState, action: \.ratingAction) {
            MySpaceRatingFeature()
        }
        Scope(state: \.timelineState, action: \.timelineAction) {
            MySpaceTimelineFeature()
        }
        Scope(state: \.galleryState, action: \.galleryAction) {
            MySpaceGalleryFeature()
        }

        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .onAppear:
                return .none
            case .wishlistAction, .calendarAction, .ratingAction, .timelineAction, .galleryAction:
                return .none
            }
        }
    }
}
