import SwiftUI

struct GoalCardView: View {
    @Bindable var goal: Goal
    var onToggleGoal: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                CategoryBadge(
                    emoji: goal.categoryEmoji,
                    name: goal.categoryName,
                    hexColor: goal.categoryColorHex
                )
                
                Spacer()
                
                // Priority pill
                HStack(spacing: 4) {
                    Image(systemName: goal.priority.icon)
                        .font(.caption2)
                    Text(goal.priority.rawValue)
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(goal.priority.color.opacity(0.25))
                .foregroundColor(.pastelTextDark)
                .cornerRadius(12)
            }
            
            HStack(alignment: .top, spacing: 12) {
                // Quick Toggle Button if single goal
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        goal.isCompleted.toggle()
                        if goal.isCompleted {
                            goal.completedAt = Date()
                            HapticManager.shared.notification(type: .success)
                        } else {
                            goal.completedAt = nil
                            HapticManager.shared.impact(style: .light)
                        }
                        onToggleGoal()
                    }
                }) {
                    ZStack {
                        Circle()
                            .stroke(goal.isCompleted ? Color.pastelSage : Color.pastelTextMuted.opacity(0.4), lineWidth: 2)
                            .background(
                                Circle()
                                    .fill(goal.isCompleted ? Color.pastelSage : Color.clear)
                            )
                            .frame(width: 26, height: 26)
                        
                        if goal.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(goal.title)
                        .font(.headline)
                        .strikethrough(goal.isCompleted, color: .pastelTextMuted)
                        .foregroundColor(goal.isCompleted ? .pastelTextMuted : .pastelTextDark)
                    
                    if !goal.goalDescription.isEmpty {
                        Text(goal.goalDescription)
                            .font(.subheadline)
                            .foregroundColor(.pastelTextMuted)
                            .lineLimit(2)
                    }
                }
            }
            
            // Subgoals Progress Bar if subgoals present
            if !goal.subgoals.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        let completedCount = goal.subgoals.filter { $0.isCompleted }.count
                        Text("\(completedCount) di \(goal.subgoals.count) completati")
                            .font(.caption)
                            .foregroundColor(.pastelTextMuted)
                        
                        Spacer()
                        
                        Text("\(goal.progressInt)%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: goal.categoryColorHex))
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.pastelTextMuted.opacity(0.15))
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(Color(hex: goal.categoryColorHex))
                                .frame(width: geometry.size.width * CGFloat(goal.progressPercentage), height: 8)
                                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: goal.progressPercentage)
                        }
                    }
                    .frame(height: 8)
                }
            }
        }
        .pastelCard(bg: goal.isCompleted ? Color.pastelCream.opacity(0.5) : Color.white)
    }
}
