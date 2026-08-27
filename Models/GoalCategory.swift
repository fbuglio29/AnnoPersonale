import Foundation
import SwiftUI
import SwiftData

@Model
final class GoalCategory {
    var id: UUID
    var name: String
    var emoji: String
    var hexColor: String
    var isDefault: Bool
    
    init(id: UUID = UUID(), name: String, emoji: String, hexColor: String, isDefault: Bool = true) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.hexColor = hexColor
        self.isDefault = isDefault
    }
    
    var color: Color {
        Color(hex: hexColor)
    }
    
    static var defaults: [GoalCategory] {[
        GoalCategory(name: "Crescita personale", emoji: "🧠", hexColor: "#C3B1E1"),
        GoalCategory(name: "Carriera", emoji: "💼", hexColor: "#A2C4C9"),
        GoalCategory(name: "Finanze", emoji: "💰", hexColor: "#F4E0A5"),
        GoalCategory(name: "Salute & Sport", emoji: "🏋️", hexColor: "#9CAF88"),
        GoalCategory(name: "Studio", emoji: "📚", hexColor: "#B5D2AD"),
        GoalCategory(name: "Viaggi", emoji: "✈️", hexColor: "#98C1D9"),
        GoalCategory(name: "Relazioni", emoji: "❤️", hexColor: "#E8C5C8"),
        GoalCategory(name: "Hobby", emoji: "🎨", hexColor: "#F2C6DE"),
        GoalCategory(name: "Vita personale", emoji: "🏠", hexColor: "#E2C0A8"),
        GoalCategory(name: "Altro", emoji: "⭐", hexColor: "#D3D3D3")
    ]}
}
