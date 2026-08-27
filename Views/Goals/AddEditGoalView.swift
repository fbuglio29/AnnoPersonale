import SwiftUI
import SwiftData

struct AddEditGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var goalToEdit: Goal?
    
    @State private var title: String = ""
    @State private var goalDescription: String = ""
    @State private var selectedCategory: GoalCategory = GoalCategory.defaults.first!
    @State private var selectedPriority: Priority = .medium
    @State private var selectedDeadlineType: DeadlineType = .none
    @State private var targetMonth: Int = 9 // September default
    @State private var tempSubgoals: [String] = []
    @State private var newSubGoalInput: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Dettagli Obiettivo")) {
                    TextField("Titolo (es. Imparare l'inglese)", text: $title)
                    TextField("Descrizione opzionale", text: $goalDescription, axis: .vertical)
                        .lineLimit(3...5)
                }
                
                Section(header: Text("Categoria")) {
                    Picker("Categoria", selection: $selectedCategory) {
                        ForEach(GoalCategory.defaults, id: \.name) { cat in
                            HStack {
                                Text(cat.emoji)
                                Text(cat.name)
                            }
                            .tag(cat)
                        }
                    }
                }
                
                Section(header: Text("Priorità e Mese Target")) {
                    Picker("Priorità", selection: $selectedPriority) {
                        ForEach(Priority.allCases) { prio in
                            Text(prio.rawValue).tag(prio)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Picker("Mese pianificato", selection: $targetMonth) {
                        Text("Settembre").tag(9)
                        Text("Ottobre").tag(10)
                        Text("Novembre").tag(11)
                        Text("Dicembre").tag(12)
                        Text("Gennaio").tag(1)
                        Text("Febbraio").tag(2)
                        Text("Marzo").tag(3)
                        Text("Aprile").tag(4)
                        Text("Maggio").tag(5)
                        Text("Giugno").tag(6)
                        Text("Luglio").tag(7)
                        Text("Agosto").tag(8)
                    }
                }
                
                Section(header: Text("Sotto-obiettivi")) {
                    ForEach(tempSubgoals, id: \.self) { sub in
                        Text(sub)
                    }
                    .onDelete { indices in
                        tempSubgoals.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Nuovo sotto-obiettivo...", text: $newSubGoalInput)
                        Button("Aggiungi") {
                            guard !newSubGoalInput.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            tempSubgoals.append(newSubGoalInput)
                            newSubGoalInput = ""
                        }
                        .disabled(newSubGoalInput.isEmpty)
                    }
                }
            }
            .navigationTitle(goalToEdit == nil ? "Nuovo Obiettivo" : "Modifica Obiettivo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Salva") {
                        saveGoal()
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if let goal = goalToEdit {
                    title = goal.title
                    goalDescription = goal.goalDescription
                    selectedPriority = goal.priority
                    targetMonth = goal.targetMonth
                    tempSubgoals = goal.subgoals.map { $0.title }
                }
            }
        }
    }
    
    private func saveGoal() {
        if let goal = goalToEdit {
            goal.title = title
            goal.goalDescription = goalDescription
            goal.categoryName = selectedCategory.name
            goal.categoryEmoji = selectedCategory.emoji
            goal.categoryColorHex = selectedCategory.hexColor
            goal.priorityRaw = selectedPriority.rawValue
            goal.targetMonth = targetMonth
        } else {
            let newGoal = Goal(
                title: title,
                goalDescription: goalDescription,
                categoryName: selectedCategory.name,
                categoryEmoji: selectedCategory.emoji,
                categoryColorHex: selectedCategory.hexColor,
                priority: selectedPriority,
                targetMonth: targetMonth
            )
            for (idx, subTitle) in tempSubgoals.enumerated() {
                let sub = SubGoal(title: subTitle, orderIndex: idx)
                sub.parentGoal = newGoal
                newGoal.subgoals.append(sub)
            }
            modelContext.insert(newGoal)
        }
        try? modelContext.save()
    }
}
