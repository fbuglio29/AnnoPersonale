import SwiftUI

struct SubGoalRowView: View {
    @Bindable var subgoal: SubGoal
    var onToggle: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    subgoal.isCompleted.toggle()
                    if subgoal.isCompleted {
                        subgoal.completedAt = Date()
                        HapticManager.shared.notification(type: .success)
                    } else {
                        subgoal.completedAt = nil
                        HapticManager.shared.impact(style: .light)
                    }
                    onToggle()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(subgoal.isCompleted ? Color.pastelSage : Color.pastelTextMuted.opacity(0.4), lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(subgoal.isCompleted ? Color.pastelSage : Color.clear)
                        )
                        .frame(width: 24, height: 24)
                    
                    if subgoal.isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            
            Text(subgoal.title)
                .font(.body)
                .strikethrough(subgoal.isCompleted, color: .pastelTextMuted)
                .foregroundColor(subgoal.isCompleted ? .pastelTextMuted : .pastelTextDark)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
