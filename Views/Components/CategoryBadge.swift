import SwiftUI

struct CategoryBadge: View {
    var emoji: String
    var name: String
    var hexColor: String
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 6) {
            Text(emoji)
                .font(.caption)
            Text(name)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .pastelTextDark)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            isSelected
            ? Color(hex: hexColor)
            : Color(hex: hexColor).opacity(0.2)
        )
        .cornerRadius(20)
    }
}
