import ComposableArchitecture

@Reducer
struct MySpaceRatingFeature {
    struct State: Equatable {}

    enum Action {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
