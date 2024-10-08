import SwiftUI
import AppRoot
import UserDatabaseClientLive
import ErrorClientLive
import TeamDatabaseClientLive
import TVShowDatabaseClientLive
import AuthenticationClientLive

@main
struct JourneyJarApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                AppRoot()
            }
        }
    }
}
