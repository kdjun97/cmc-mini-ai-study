import ComposableArchitecture

@Reducer
struct MySpaceCalendarFeature {
    struct State: Equatable {}

    enum Action {
        case aspectRatioTapped
        case favoriteTapped
        case shareTapped
        case settingsTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .aspectRatioTapped:
                return .none
            case .favoriteTapped:
                return .none
            case .shareTapped:
                return .none
            case .settingsTapped:
                return .none
            }
        }
    }
}
