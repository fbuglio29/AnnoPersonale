import SwiftUI
import SwiftData

struct GoalDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var goal: Goal
    
    @State private var showingEditSheet = false
    @State private var newSubGoalTitle = ""
    @State private var confettiTrigger = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Badge & Priority
                HStack {
                    CategoryBadge(
                        emoji: goal.categoryEmoji,
                        name: goal.categoryName,
                        hexColor: goal.categoryColorHex
                    )
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Image(systemName: goal.priority.icon)
                        Text("Priorità \(goal.priority.rawValue)")
                    }
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(goal.priority.color.opacity(0.3))
                    .cornerRadius(12)
                }
                
                // Title & Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(goal.title)
                        .font(.system(size: 26, weight: .bold, design: .serif))
                        .foregroundColor(.pastelTextDark)
                    
                    if !goal.goalDescription.isEmpty {
                        Text(goal.goalDescription)
                            .font(.body)
                            .foregroundColor(.pastelTextMuted)
                    }
                }
                
                // Completion Progress Box
                VStack(spacing: 12) {
                    HStack {
                        Text("Avanzamento")
                            .font(.headline)
                            .foregroundColor(.pastelTextDark)
                        Spacer()
                        Text("\(goal.progressInt)%")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: goal.categoryColorHex))
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color.pastelTextMuted.opacity(0.2))
                                .frame(height: 12)
                            Capsule()
                                .fill(Color(hex: goal.categoryColorHex))
                                .frame(width: geo.size.width * CGFloat(goal.progressPercentage), height: 12)
                                .animation(.spring, value: goal.progressPercentage)
                        }
                    }
                    .frame(height: 12)
                }
                .pastelCard()
                
                // Sub-goals Checklist Section
                VStack(alignment: .leading, spacing: 14) {
                    Text("Sotto-obiettivi")
                        .font(.headline)
                        .foregroundColor(.pastelTextDark)
                    
                    ForEach(goal.subgoals.sorted(by: { $0.orderIndex < $1.orderIndex })) { sub in
                        SubGoalRowView(subgoal: sub, onToggle: {
                            goal.checkAutoCompletion()
                            if goal.isCompleted {
                                confettiTrigger = true
                            }
                            try? modelContext.save()
                        })
                    }
                    
                    // Add new subgoal inline
                    HStack {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.pastelSage)
                        TextField("Aggiungi sotto-obiettivo...", text: $newSubGoalTitle)
                            .onSubmit(addSubGoal)
                        if !newSubGoalTitle.isEmpty {
                            Button("Aggiungi", action: addSubGoal)
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.pastelSage)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .pastelCard()
                
                // Notes Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Note personali")
                        .font(.headline)
                        .foregroundColor(.pastelTextDark)
                    
                    TextEditor(text: $goal.notes)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.pastelCream)
                        .cornerRadius(12)
                }
                .pastelCard()
                
                // Metadata dates
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Image(systemName: "calendar")
                        Text("Creato il: \(goal.createdAt.formatted(date: .abbreviated, time: .omitted))")
                    }
                    if let completedDate = goal.completedAt {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.pastelSage)
                            Text("Completato il: \(completedDate.formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                }
                .font(.caption)
                .foregroundColor(.pastelTextMuted)
                .padding(.horizontal, 4)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        withAnimation {
                            goal.isCompleted.toggle()
                            if goal.isCompleted {
                                goal.completedAt = Date()
                                confettiTrigger = true
                                HapticManager.shared.notification(type: .success)
                            } else {
                                goal.completedAt = nil
                            }
                            try? modelContext.save()
                        }
                    }) {
                        HStack {
                            Image(systemName: goal.isCompleted ? "arrow.uturn.backward" : "checkmark")
                            Text(goal.isCompleted ? "Segna come in corso" : "Segna come completato")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(goal.isCompleted ? Color.pastelTextMuted : Color.pastelSage)
                        .cornerRadius(16)
                    }
                }
                .padding(.top, 12)
            }
            .padding(20)
        }
        .background(Color.pastelCream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Modifica") {
                    showingEditSheet = true
                }
                .foregroundColor(.pastelSage)
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            AddEditGoalView(goalToEdit: goal)
        }
        .overlay(
            ZStack {
                if confettiTrigger {
                    MinimalConfettiView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                confettiTrigger = false
                            }
                        }
                }
            }
        )
    }
    
    private func addSubGoal() {
        guard !newSubGoalTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let sub = SubGoal(title: newSubGoalTitle, orderIndex: goal.subgoals.count)
        sub.parentGoal = goal
        goal.subgoals.append(sub)
        newSubGoalTitle = ""
        goal.checkAutoCompletion()
        try? modelContext.save()
    }
}
