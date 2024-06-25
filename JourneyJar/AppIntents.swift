import AppIntents

public struct AddTVShow: AppIntent {
    public static let title = LocalizedStringResource("Add TV Show")
    public static var description: IntentDescription? { IntentDescription("Use this action to add a TV show to JourneyJar") }
    
    public init() {}
    
    @MainActor
    public func perform() async throws -> some IntentResult {
        print("adding tv show")
        return .result()
    }
}

struct JourneyJarFrameworkPackage: AppIntentsPackage { }

struct MyAppPackage: AppIntentsPackage {
   static var includedPackages: [any AppIntentsPackage.Type] {
       [MyFrameworkPackage.self]
   }
}
