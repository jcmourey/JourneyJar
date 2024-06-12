//
//  JourneyJarApp.swift
//  JourneyJar
//
//  Created by Jean-Charles Mourey on 08/06/2024.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore
import FirebaseAppCheck

@main
struct JourneyJarApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @MainActor
    static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
    }
    
    init() {
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AppView(store: Self.store)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
}
