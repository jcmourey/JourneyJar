//
//  FirebaseAuthView.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 18/06/2024.
//

import FirebaseAuthUI
import UIKit
import SwiftUI
import ComposableArchitecture
import FirebaseAuthUI
import FirebaseEmailAuthUI
import FirebaseGoogleAuthUI
import FirebaseOAuthUI
import FirebaseFacebookAuthUI

@Reducer
struct FirebaseSignIn {
    @ObservableState
    struct State: Equatable {
    }
    
    enum Action {
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}

struct FirebaseSignInView {
    let store: StoreOf<FirebaseSignIn>
    
    var body: some View {
        FirebaseAuthView
    }
}

struct FirebaseAuthView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    
    class Coordinator: NSObject, FUIAuthDelegate {
        var parent: FirebaseAuthView
        
        init(parent: FirebaseAuthView) {
            self.parent = parent
        }
        
        private func upgradeAnonymous(mergeConflict error:  NSError) {
            // Merge conflict error, discard the anonymous user and login as the existing
            // non-anonymous user.
            guard let credential = error.userInfo[FUIAuthCredentialKey] as? AuthCredential else {
                print("Received merge conflict error without auth credential!")
                return
            }
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error {
                    print("Failed to re-login: \(error)")
                }
                // Handle successful login
                self.parent.dismiss()
            }
        }
        
        func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
            switch (authDataResult, (error as NSError?)) {
                
            case let (.none, .some(error)) where error.code == FUIAuthErrorCode.userCancelledSignIn.rawValue:
                // user hit cancel button
                parent.dismiss()
            
            case let (.none, .some(error)) where error.code == FUIAuthErrorCode.mergeConflict.rawValue:
                // anonymous signed in with credential
                upgradeAnonymous(mergeConflict: error)
                
            case let (_, .some(error)):
                // Some other error happened.
                print("Failed to log in: \(error)")
                // Handle successful login
                parent.dismiss()
                
            case (.none, .none):
                print("No error but no authDataResult either: shouldn't happen")
                parent.dismiss()
                
            case (.some(_), .none):
                // Handle successful login
                parent.dismiss()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
    func makeUIViewController(context: Context) -> UINavigationController {
        
        guard let authUI = FUIAuth.defaultAuthUI() else {
            print("unable to get FUIAuth.defaultAuthUI() instance")
            return UINavigationController()
        }
        
        authUI.delegate = context.coordinator
        
        let providers: [FUIAuthProvider] = [
            FUIOAuth.appleAuthProvider(),
            FUIGoogleAuth(authUI: authUI),
            // FUIFacebookAuth(),
            // FUIPhoneAuth(authUI: authUI!),
//            FUIOAuth.twitterAuthProvider(),
//            FUIOAuth.githubAuthProvider(),
//            FUIOAuth.microsoftAuthProvider(),
//            FUIOAuth.yahooAuthProvider(),
        ]
        
        authUI.providers = providers
        authUI.shouldAutoUpgradeAnonymousUsers = true

        return authUI.authViewController()
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}
