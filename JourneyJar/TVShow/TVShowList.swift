//
//  TVShowList.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 08/06/2024.
//

import SwiftUI
import ComposableArchitecture
import IdentifiedCollections
import Tagged

@Reducer
struct TVShowList {
    @Reducer(state: .equatable)
    enum Destination {
        case add(TVShowForm)
    }
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        @Shared(.tvShows) var tvShows
        
        var sortedTVShowElements: some RandomAccessCollection<Shared<TVShow>> {
            $tvShows.elements.sorted { show0, show1 in
                guard let score0 = show0.wrappedValue.tvdbInfo?.score else { return false }
                guard let score1 = show1.wrappedValue.tvdbInfo?.score else { return true }
                return score0 > score1
            }
        }
    }
    enum Action {
        case fetchResponse(IdentifiedArrayOf<TVShow>)
        case fetch
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: TVShow.ID)
        case cancelAddButtonTapped
        case confirmAddButtonTapped
        case addButtonTapped
    }
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.date.now) var now
    @Dependency(\.dismiss) var dismiss
//    @Dependency(\.firebase) var firebase
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fetchResponse(tvShows):
                state.tvShows = tvShows
                return .none
                
            case .fetch:
                return .run { send in
                    guard let tvShows: IdentifiedArrayOf<TVShow> = try? await FirebaseService().fetch("tvShows") else { return }
                    await send(.fetchResponse(tvShows))
                }
                
            case .destination:
                return .none
                
            case let .deleteButtonTapped(id):
                state.tvShows.remove(id: id)
                return .none
            
            case .cancelAddButtonTapped:
                state.destination = nil
                return .none
                
            case .confirmAddButtonTapped:
                guard var newTVShow = state.destination?.add?.tvShow else { return .none }
                if let tvdbName = newTVShow.tvdbInfo?.name {
                    newTVShow.title = tvdbName
                }
                state.tvShows.append(newTVShow)
                state.destination = nil
                return .run { [tvShow = newTVShow] send in
                    try? await FirebaseService().add(tvShow, to: "tvShows")
                }
                
            case .addButtonTapped:
                let newTVShow = TVShow(id: TVShow.ID(uuid()), dateAdded: now, dateModified: now)
                state.destination = .add(TVShowForm.State(tvShow: newTVShow, focus: .title))
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }
}

struct TVShowListView: View {
    @Perception.Bindable var store: StoreOf<TVShowList>
    
    var body: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVGrid(columns: Layout.gridItems) {
                    ForEach(store.sortedTVShowElements) { $tvShow in
                        NavigationLink(state: AppFeature.Path.State.detail(TVShowDetail.State(tvShow: $tvShow))) {
                            Thumbnail(url: tvShow.tvdbInfo?.imageURL, altText: tvShow.title, showError: false)
                                .contextMenu {
                                    deleteButton(id: tvShow.id)
                                }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .navigationTitle("TV Shows")
            .sheet(item: $store.scope(state: \.destination?.add, action: \.destination.add)) { addStore in
                addView(addStore: addStore)
            }
            .toolbar { addButton }
            .onAppear {
                store.send(.fetch)
            }
        }
    }
    
    @ViewBuilder private var addButton: some View {
        Button {
            store.send(.addButtonTapped)
        } label: {
            Label("Add TV Show", systemImage: "plus")
        }
    }
    
    @ViewBuilder private func deleteButton(id: TVShow.ID) -> some View {
        Button(role: .destructive) {
            store.send(.deleteButtonTapped(id: id))
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    @ViewBuilder private func addView(addStore: StoreOf<TVShowForm>) -> some View {
        NavigationStack {
            TVShowFormView(store: addStore)
                .navigationTitle("New TV Show")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Discard") {
                            store.send(.cancelAddButtonTapped)
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            store.send(.confirmAddButtonTapped)
                        }
                    }
                }
        }
    }
}

#Preview {
    NavigationStack {   
        @Shared(.tvShows) var tvShows = .mock
        
        let store = Store(initialState: TVShowList.State()) {
            TVShowList()
            ._printChanges()
        }
        
        TVShowListView(store: store)
    }
}

