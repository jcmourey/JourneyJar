//
//  FilePersistence.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 12/06/2024.
//

import ComposableArchitecture
import Foundation
import IdentifiedCollections

extension PersistenceReaderKey where Self == PersistenceKeyDefault<FileStorageKey<IdentifiedArrayOf<TVShow>>> {
    static var tvShows: Self {
        PersistenceKeyDefault(.fileStorage(.documentsDirectory.appending(component: "tvShows.json")), [])
    }
}

extension PersistenceReaderKey where Self == PersistenceKeyDefault<FirebaseKey<IdentifiedArrayOf<TVShow>>> {
    static var tvShowsFirebase: Self {
        PersistenceKeyDefault(.firebase("tvShows"), [])
    }
}

extension PersistenceReaderKey {
    public static func firebase<Value: Codable>(_ collection: String) -> Self where Self == FirebaseKey<Value> {
        FirebaseKey(collection: collection)
  }
}

public final class FirebaseKey<Value: Codable & Sendable>: PersistenceKey, Sendable {
    private let collection: String
    
    fileprivate init(collection: String) {
        self.collection = collection
    }
    
    public func save(_ value: Value) {}
    
    public var id: String { collection }
    
    public func load(initialValue: Value?) -> Value? {
        return nil
    }
}
