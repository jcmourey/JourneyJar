//
//  File.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 21/06/2024.
//

import Foundation
import FirebaseAuth
@preconcurrency import FirebaseFirestore
import ComposableArchitecture

struct UserInfo: FirebaseRepresentable {
    @DocumentID var id: String?
    let uid: String
    let name: String?
    let photoURL: URL?
    let isAnonymous: Bool
    let isEmailVerified: Bool
    let creationDate: Date?
    let lastSignInDate: Date?
    let tenantID: String?
    let email: String?
    let phoneNumber: String?
    let signInProvider: String?
    let signInName: String?
    
    init(id: String? = nil, uid: String, name: String?, photoURL: URL?, isAnonymous: Bool, isEmailVerified: Bool, creationDate: Date?, lastSignInDate: Date?, tenantID: String?, email: String?, phoneNumber: String?, signInProvider: String?, signInName: String?) {
        self.id = id
        self.uid = uid
        self.name = name
        self.photoURL = photoURL
        self.isAnonymous = isAnonymous
        self.isEmailVerified = isEmailVerified
        self.creationDate = creationDate
        self.lastSignInDate = lastSignInDate
        self.tenantID = tenantID
        self.email = email
        self.phoneNumber = phoneNumber
        self.signInProvider = signInProvider
        self.signInName = signInName
    }
    
    init?(from user: User?, with name: String?) {
        guard let user else { return nil }
        let provider = user.providerData.first

        self.init(
            uid: user.uid,
            name: name,
            photoURL: user.photoURL,
            isAnonymous: user.isAnonymous,
            isEmailVerified: user.isEmailVerified,
            creationDate: user.metadata.creationDate,
            lastSignInDate: user.metadata.lastSignInDate,
            tenantID: user.tenantID,
            email: user.email,
            phoneNumber: user.phoneNumber,
            signInProvider: provider?.providerID,
            signInName: provider?.displayName
        )
        
    }

    
    static var currentUser: UserInfo? {
        @Shared(.userName) var userName
        
        return UserInfo(from: Auth.auth().currentUser, with: userName)
    }
}
