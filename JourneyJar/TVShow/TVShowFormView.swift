//
//  TVShowFormView.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 12/06/2024.
//

import ComposableArchitecture
import SwiftUI

struct TVShowFormView: View {
    @Perception.Bindable var store: StoreOf<TVShowForm>
    @FocusState var focus: TVShowForm.State.Field?
    
    var body: some View {
        WithPerceptionTracking {
            Form {
                Section("TVShow Info") {
                    TextField("Title", text: $store.tvShow.title, axis: .vertical)
                        .navTitleStyle()
                        .focused($focus, equals: .title)
                    
                    KeyContentPair("How interested are you in the show?") {
                        RatingView(level: $store.tvShow.interest)
                    }
                    
                    KeyContentPair("Where are you with the show?", axis: .vertical) {
                        Picker("Progress", selection: $store.tvShow.progress) {
                            ForEach(TVShow.Progress.allCases, id: \.self) { progress in
                                Text(progress.rawValue)
                                    .tag(progress as TVShow.Progress?)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle.segmentedIfAvailable)
                    }
                }
                
                Section("Recommendations") {
                    ForEach($store.tvShow.recommendations) { $recommendation in
                        TextField("Name", text: $recommendation.name)
                            .focused($focus, equals: .recommendation(recommendation.id))
                    }
                    .onDelete { indices in
                        store.send(.onDeleteRecommendations(indices))
                    }
                    
                    Button("Add recommendation") {
                        store.send(.addRecommendationButtonTapped)
                    }
                }
                
                Section("TVDB Info") {
                    if let errorDescription = store.errorDescription {
                        Text(errorDescription)
                            .font(.caption)
                    }
                    
                    HStack {
                        Button {
                            store.send(.previousTVDBSeriesButtonTapped)
                        } label: {
                            Image(systemName: "chevron.left")
                            Text("\(store.seriesCountBefore)")
                        }
                        .disabled(store.seriesCountBefore == 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button("Refresh") {
                            store.send(.refresh)
                        }
                        .disabled(store.tvShow.title.isEmpty)
                        .frame(maxWidth: .infinity, alignment: .center)

                        Button {
                            store.send(.nextTVDBSeriesButtonTapped)
                        } label: {
                            Text("\(store.seriesCountAfter)")
                            Image(systemName: "chevron.right")
                        }
                        .disabled(store.seriesCountAfter == 0)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                   }
                    .buttonStyle(.borderless)
                    
                    if let info = store.tvShow.tvdbInfo {
                        OptionalText(info.name)
                            .navTitleStyle(font: .title)
                        
                        TVDBInfoView(info: info)
                    }
                }
            }
            .bind($store.focus, to: $focus)
            .task(id: store.tvShow.title) {
                store.send(.titleChanged)
            }
            .refreshable {
                store.send(.refresh)
            }
        }
    }
}

#Preview("Edit TV Show") {
    NavigationStack {
        let store = Store(initialState: TVShowForm.State(tvShow: .mock.mock2, focus: nil)) {
            TVShowForm()
        }
        TVShowFormView(store: store)
    }
}

#Preview("Add TV Show") {
    NavigationStack {
        let store = Store(initialState: TVShowForm.State(tvShow: TVShow(id: TVShow.ID(), dateAdded: .now, dateModified: .now), focus: .title)) {
            TVShowForm()
        }
        TVShowFormView(store: store)
    }
}

