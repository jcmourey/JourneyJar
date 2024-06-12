//
//  App.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 10/06/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    @Reducer(state: .equatable)
    enum Path {
        case detail(TVShowDetail)
    }
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var tvShowList = TVShowList.State()
    }
    
    enum Action {
        case path(StackActionOf<Path>)
        case tvShowList(TVShowList.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tvShowList, action: \.tvShowList) {
            TVShowList()
        }
        Reduce { state, action in
            switch action {
            case .path:
                return .none
                
            case .tvShowList:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

struct AppView: View {
    @Perception.Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                TVShowListView(store: store.scope(state: \.tvShowList, action: \.tvShowList))
            } destination: { store in
                switch store.case {
                case let .detail(detailStore):
                    TVShowDetailView(store: detailStore)
                }
            }
        }
    }
}

#Preview {
    @Shared(.tvShows) var tvShows = .mock
    
    let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    return AppView(store: store)
}
