//
//  FirebaseService.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 12/06/2024.
//

import Foundation
import FirebaseFirestore
import IdentifiedCollections
import FirebaseDatabase

class FirebaseService {
    let db = Firestore.firestore()

    enum FirebaseError: Error {
        case jsonSerialization
    }
    
    func add<T: Codable>(_ document: T, to collection: String) async throws {
        let data = try JSONEncoder().encode(document)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        guard let jsonDictionary = jsonObject as? [String: Any] else {
            throw FirebaseError.jsonSerialization
        }
        try await db.collection(collection).addDocument(data: jsonDictionary)
    }
    
    func fetch<T: Codable>(_ collection: String) async throws -> IdentifiedArrayOf<T> {
        let documents = try await db
            .collection(collection)
            .getDocuments()
            .documents
        
        print("\(documents.count) \(collection) fetched")
        
        let fetchedObjects: [T] = documents
            .compactMap { document in
                guard JSONSerialization.isValidJSONObject(document.data()) else {
                    print("invalid JSON Object")
                    return nil
                }
                guard let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                      let object = try? JSONDecoder().decode(T.self, from: data) else {
                    print("failure to decode Firebase data")
                    return nil
                }
                return object
            }
    
        return IdentifiedArray(uniqueElements: fetchedObjects)
    }
    
//    func save<T: Codable>(_ document: T, to collection: String) async throws {
//        try await db
//            .collection(collection)
//            .
//
//    func saveTVShows(tvShows: IdentifiedArrayOf<TVShow>) {
//        let ref = Database.database().reference()
//        
//        Database.database()
//            .reference()
//            .
            
//        ref.collection("tvShows").document().setValue(tvShows) { error, ref in
//            if let error = error {
//                print("Error saving data: \(error)")
//            } else {
//                print("Data saved successfully!")
//            }
//        }
//    }
}
