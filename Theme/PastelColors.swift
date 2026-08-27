import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // High Contrast Vibrant Theme Palette
    static let pastelSage = Color(hex: "#10B981") // Emerald Green Primary
    static let pastelPowderBlue = Color(hex: "#6366F1") // Indigo Accent
    static let pastelLavender = Color(hex: "#8B5CF6") // Violet Accent
    static let pastelBlushPink = Color(hex: "#F43F5E") // Rose Accent
    static let pastelYellow = Color(hex: "#F59E0B") // Amber Gold Accent
    static let pastelCream = Color(hex: "#F8FAFC") // Slate Light BG
    static let pastelCardBg = Color(hex: "#FFFFFF")
    static let pastelTextDark = Color(hex: "#0F172A") // Slate Dark High Contrast
    static let pastelTextMuted = Color(hex: "#64748B") // Slate Muted
}

struct PastelCardStyle: ViewModifier {
    var backgroundColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .cornerRadius(22)
            .shadow(color: Color(hex: "#0F172A").opacity(0.04), radius: 12, x: 0, y: 6)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color(hex: "#E2E8F0"), lineWidth: 1)
            )
    }
}

extension View {
    func pastelCard(bg: Color = .white) -> some View {
        modifier(PastelCardStyle(backgroundColor: bg))
    }
}
