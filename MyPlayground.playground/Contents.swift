import Tagged

struct Cell: Codable, Identifiable {
    let id: Tagged<Self, UUID> = UUID()
}

let x = String(describing: Cell().id)
