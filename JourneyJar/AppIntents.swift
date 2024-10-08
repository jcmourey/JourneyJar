import AppIntents
import TVShowModel
import ComposableArchitecture
import Tagged
import TVShowFeature

struct AddTVShowIntent: AppIntent {
    static let title = LocalizedStringResource("Add TV Show")
    static var description: IntentDescription? { IntentDescription("Use this action to add a TV show") }
    
    @Parameter(title: "Title", description: "Title of the TV show")
    var title: String?
    
    static var parameterSummary: some ParameterSummary {
      Summary("Add a new TV show named \(\.$title)")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<TVShowEntity> & ProvidesDialog {
        guard let title else {
            throw $title.needsValueError("Provide a title")
        }
        let store: StoreOf<TVShowList> = Store(initialState: TVShowList.State()) {
            TVShowList()
        }
        await store.send(.addTVShowAppIntent(title)).finish()
        guard let tvShow = store.state.lastTVShowAdded else {
            throw $title.needsValueError("Unable to add TV show, sorry")
        }
        let tvShowEntity = TVShowEntity(tvShow: tvShow)
        
        let message = if let network = tvShow.tvdbInfo?.network {
            "You added \(tvShow.title) (\(network))"
        } else {
            "You added \(tvShow.title)"
        }
        return .result(value: tvShowEntity, dialog: IntentDialog(stringLiteral: message))
    }
}

extension Tagged: @retroactive EntityIdentifierConvertible where RawValue == UUID {
    public var entityIdentifierString: String {
        rawValue.uuidString
    }
    
    public static func entityIdentifier(for entityIdentifierString: String) -> Tagged<Tag, UUID>? {
        guard let id = UUID(uuidString: entityIdentifierString) else { return nil }
        return Tagged(id)
    }
}

public struct TVShowEntity: AppEntity {
    public static var defaultQuery: TVShowQuery { .init() }
        
    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "TV Show"
    }
       
    public var id: UUID { tvShow.id.rawValue }
    public var tvShow: TVShow
    
    public var displayRepresentation: DisplayRepresentation {
        let subtitle: LocalizedStringResource? = if let network = tvShow.tvdbInfo?.network {
            LocalizedStringResource(stringLiteral: network)
        } else { 
            nil
        }

        return DisplayRepresentation(
            title: LocalizedStringResource(stringLiteral: tvShow.title),
            subtitle: subtitle,
            image: nil
        )
    }
}


public struct TVShowQuery: EntityQuery {
    public init() {}
    
    public func entities(for identifiers: [TVShowEntity.ID]) async throws -> [TVShowEntity] {
        []
    }
    
    public func suggestedEntities() async throws -> [TVShowEntity] {
    []
    }
}

struct JourneyJarShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTVShowIntent(),
            phrases: [
                "New TV show in \(.applicationName)",
                "Add TV show in \(.applicationName)",
                "Create TV Show in \(.applicationName)",
            ],
            shortTitle: "New TV Show",
            systemImageName: "tv"
        )
    }
    
    static var shortcutTileColor: ShortcutTileColor { .blue }
}
