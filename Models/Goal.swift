import Foundation
import SwiftData

@Model
final class Goal {
    var id: UUID
    var title: String
    var goalDescription: String
    var categoryName: String
    var categoryEmoji: String
    var categoryColorHex: String
    var priorityRaw: String
    var deadlineTypeRaw: String
    var targetDate: Date?
    var targetMonth: Int // 1-12 representing month in personal year
    var isCompleted: Bool
    var completedAt: Date?
    var createdAt: Date
    var isArchived: Bool
    var notes: String
    
    @Relationship(deleteRule: .cascade)
    var subgoals: [SubGoal] = []
    
    @Relationship(inverse: \PersonalYearCycle.goals)
    var yearCycle: PersonalYearCycle?
    
    init(
        id: UUID = UUID(),
        title: String,
        goalDescription: String = "",
        categoryName: String = "Crescita personale",
        categoryEmoji: String = "🧠",
        categoryColorHex: String = "#C3B1E1",
        priority: Priority = .medium,
        deadlineType: DeadlineType = .none,
        targetDate: Date? = nil,
        targetMonth: Int = 9, // Default September
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        createdAt: Date = Date(),
        isArchived: Bool = false,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.goalDescription = goalDescription
        self.categoryName = categoryName
        self.categoryEmoji = categoryEmoji
        self.categoryColorHex = categoryColorHex
        self.priorityRaw = priority.rawValue
        self.deadlineTypeRaw = deadlineType.rawValue
        self.targetDate = targetDate
        self.targetMonth = targetMonth
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.createdAt = createdAt
        self.isArchived = isArchived
        self.notes = notes
    }
    
    var priority: Priority {
        Priority(rawValue: priorityRaw) ?? .medium
    }
    
    var deadlineType: DeadlineType {
        DeadlineType(rawValue: deadlineTypeRaw) ?? .none
    }
    
    var progressPercentage: Double {
        if subgoals.isEmpty {
            return isCompleted ? 1.0 : 0.0
        }
        let completedCount = subgoals.filter { $0.isCompleted }.count
        return Double(completedCount) / Double(subgoals.count)
    }
    
    var progressInt: Int {
        Int(progressPercentage * 100)
    }
    
    func checkAutoCompletion() {
        guard !subgoals.isEmpty else { return }
        let allDone = subgoals.allSatisfy { $0.isCompleted }
        if allDone && !isCompleted {
            isCompleted = true
            completedAt = Date()
        } else if !allDone && isCompleted {
            isCompleted = false
            completedAt = nil
        }
    }
    
    var targetMonthName: String {
        let monthNames = ["", "Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio", "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"]
        guard targetMonth >= 1 && targetMonth <= 12 else { return "Anno" }
        return monthNames[targetMonth]
    }
}
