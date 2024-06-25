//
//  Profile.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 19/06/2024.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAuth
import FirebaseAuthUI

@Reducer
struct UserFeature {
    @ObservableState
    struct State: Equatable {
        @Shared(.appStorage("userName")) var userName: String? = nil
        
        var currentUser: User? { Auth.auth().currentUser }
        
        var displayName: String? {
            if let userName { userName } else { currentUser?.displayName }
        }
    }
    enum Action {
        case editDisplayNameButtonTapped
        case signOutButtonTapped
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .editDisplayNameButtonTapped:
                return .none
                
            case .signOutButtonTapped:
                return .run { _ in
                    do {
                        try FUIAuth.defaultAuthUI()?.signOut()
                        await dismiss()
                    } catch {
                        print("error signing out: \(error)")
                    }
                }
            }
        }
    }
}

struct UserView: View {
    let store: StoreOf<UserFeature>
    
    var body: some View {
        List {
            HStack {
                ProfileImage(user: store.currentUser)
                    .frame(width: 100, height: 100)

                if let displayName = store.displayName {
                    Text(displayName)
                        .navTitleStyle()
                }
            }
            
            if let user = store.currentUser {
                UserInfoView(user: user)
                
                Section {
                    Button(role: .destructive) {
                        store.send(.signOutButtonTapped)
                    } label: {
                        Text("Sign Out")
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("User profile")
    }
    
    struct UserInfoView: View {
        let user: User
        
        var body: some View {
            Section("User Info") {
                KeyValuePair("uid", user.uid)
                KeyValuePair("is Anonymous", user.isAnonymous)
                KeyValuePair("is Email Verified", user.isEmailVerified)
                KeyValuePair("last Sign In Date", user.metadata.lastSignInDate)
                KeyValuePair("creation Date", user.metadata.creationDate)
                KeyValuePair("tenant ID", user.tenantID)
                KeyValuePair("email", user.email)
                KeyValuePair("phone Number", user.phoneNumber)
            }
            
            ForEach(user.providerData, id: \.providerID) { info in
                ProviderInfoView(info: info)
            }
            ForEach(user.multiFactor.enrolledFactors, id: \.factorID) { info in
                MultiFactorInfoView(info: info)
            }
        }
    }
    
    struct ProviderInfoView: View {
        let info: UserInfo
        
        var body: some View {
            Section("Provider: \(info.providerID)") {
                KeyValuePair("uid", info.uid)
                KeyValuePair("display Name", info.displayName)
                KeyValuePair("photo URL", info.photoURL)
                KeyValuePair("email", info.email)
                KeyValuePair("phone Number", info.phoneNumber)
            }
        }
    }
    
    struct MultiFactorInfoView: View {
        let info: MultiFactorInfo
        
        var body: some View {
            Section("Factor: \( info.factorID)") {
                KeyValuePair("uid", info.uid)
                KeyValuePair("display Name", info.displayName)
                KeyValuePair("enrollment Date", info.enrollmentDate)
            }
        }
    }
}

struct ProfileImage: View {
    let user: User?
    
    var body: some View {
        if let userPhotoURL = user?.photoURL {
            Thumbnail(url: userPhotoURL)
        } else {
            Image(systemName: defaultUserSystemImage)
        }
    }

    var defaultUserSystemImage: String {
        switch user?.providerData.first?.providerID {
        case .none: return "person"
        case .some("apple.com"): return "apple.logo"
        default: return "person.fill"
        }
    }
}

#Preview {
    let store = Store(initialState: UserFeature.State()) {
        UserFeature()
    }
    return UserView(store: store)
}

extension User? {
    
}
