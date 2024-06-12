//
//  TVShowDetail.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 10/06/2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct TVShowDetail: Reducer {
    @Reducer(state: .equatable)
    enum Destination {
        case alert(AlertState<Alert>)
        case edit(TVShowForm)
        @CasePathable
        enum Alert {
            case confirmDeleteButtonTapped
        }
    }
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        @Shared var tvShow: TVShow
    }
    enum Action {
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped
        case cancelEditButtonTapped
        case doneEditingButtonTapped
        case editButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .destination(.presented(.alert(.confirmDeleteButtonTapped))):
                @Shared(.tvShows) var tvShows
                tvShows.remove(id: state.tvShow.id)
                return .run { _ in await dismiss() }
                
            case .destination:
                return .none
                
            case .deleteButtonTapped:
                state.destination = .alert(.delete)
                return .none
            
            case .cancelEditButtonTapped:
                state.destination = nil
                return .none

            case .doneEditingButtonTapped:
                guard let editedTVShow = state.destination?.edit?.tvShow else { return .none }
                state.tvShow = editedTVShow
                if let tvdbName = state.tvShow.tvdbInfo?.name {
                    state.tvShow.title = tvdbName
                }
                state.destination = nil
                return .none
            
            case .editButtonTapped:
                state.destination = .edit(TVShowForm.State(tvShow: state.tvShow, focus: nil))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

extension AlertState where Action == TVShowDetail.Destination.Alert {
    static let delete = Self {
        TextState("Delete?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDeleteButtonTapped) {
            TextState("Yes")
        }
        ButtonState(role: .cancel) {
            TextState("Nevermind")
        }
    } message: {
        TextState("Are you sure you want to delete this TV show?")
    }
}

struct TVShowDetailView: View {
    @Perception.Bindable var store: StoreOf<TVShowDetail>
    
    var body: some View {
        WithPerceptionTracking {
            Form {
                Text(store.tvShow.title)
                    .navTitleStyle()
                
                Section("TVShow Info") {
                    KeyContentPair("Interest") {
                        RatingView(level: store.tvShow.interest)
                    }
                    
                    KeyValuePair("Progress", store.tvShow.progress)
                }
                
                if !store.tvShow.recommendations.isEmpty {
                    Section("Recommendations") {
                        ForEach(store.tvShow.recommendations) { recommendation in
                            Text(recommendation.name)
                        }
                    }
                }
                        
                Section {
                    Button("Delete", role: .destructive) {
                        store.send(.deleteButtonTapped)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                if let info = store.tvShow.tvdbInfo {
                    Section("TVDB Info") {
                        TVDBInfoView(info: info)
                    }
                }
                
            }
            .toolbar {
                Button("Edit") {
                    store.send(.editButtonTapped)
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
            .sheet(item: $store.scope(state: \.destination?.edit, action: \.destination.edit)) { editStore in
                NavigationStack {
                    TVShowFormView(store: editStore)
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    store.send(.cancelEditButtonTapped)
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    store.send(.doneEditingButtonTapped)
                                }
                            }
                        }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        let store = Store(initialState: TVShowDetail.State(tvShow: Shared(.mock.mock2))) {
            TVShowDetail()
        }
        TVShowDetailView(store: store)
    }
}
