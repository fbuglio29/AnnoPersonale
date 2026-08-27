import Foundation
import SwiftUI

enum Priority: String, Codable, CaseIterable, Identifiable {
    case low = "Bassa"
    case medium = "Media"
    case high = "Alta"
    
    var id: String { rawValue }
    
    var color: Color {
        switch self {
        case .low:
            return Color(hex: "#A2C4C9") // Powder Blue
        case .medium:
            return Color(hex: "#F4E0A5") // Soft Yellow
        case .high:
            return Color(hex: "#E8C5C8") // Blush Pink
        }
    }
    
    var icon: String {
        switch self {
        case .low: return "arrow.down"
        case .medium: return "minus"
        case .high: return "exclamationmark"
        }
    }
}

enum DeadlineType: String, Codable, CaseIterable, Identifiable {
    case none = "Nessuna"
    case specificDate = "Data specifica"
    case specificMonth = "Mese specifico"
    case endOfYear = "Fine anno personale"
    
    var id: String { rawValue }
}
