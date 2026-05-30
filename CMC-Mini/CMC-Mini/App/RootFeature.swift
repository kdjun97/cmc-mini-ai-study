import ComposableArchitecture

@Reducer
struct RootFeature {
    @ObservableState
    struct State: Equatable {
        var selectedTab: CMCTab = .mySpace
        var socialState: SocialFeature.State = .init()
        var searchState: SearchFeature.State = .init()
        var mySpaceState: MySpaceFeature.State = .init()
        var profileState: ProfileFeature.State = .init()
    }

    enum Action: BindableAction {
        case binding(BindingAction<State>)
        case socialAction(SocialFeature.Action)
        case searchAction(SearchFeature.Action)
        case mySpaceAction(MySpaceFeature.Action)
        case profileAction(ProfileFeature.Action)
    }

    var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.socialState, action: \.socialAction) {
            SocialFeature()
        }
        Scope(state: \.searchState, action: \.searchAction) {
            SearchFeature()
        }
        Scope(state: \.mySpaceState, action: \.mySpaceAction) {
            MySpaceFeature()
        }
        Scope(state: \.profileState, action: \.profileAction) {
            ProfileFeature()
        }

        Reduce { state, action in
            return .none
        }
    }
}
