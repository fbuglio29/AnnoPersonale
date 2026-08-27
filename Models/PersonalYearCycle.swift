import Foundation
import SwiftData

@Model
final class PersonalYearCycle {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
    var isCurrent: Bool
    var motivationalQuote: String
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var goals: [Goal] = []
    
    @Relationship(deleteRule: .cascade)
    var reviews: [YearReview] = []
    
    init(
        id: UUID = UUID(),
        title: String = "Settembre 2026 → Agosto 2027",
        startDate: Date = Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 1)) ?? Date(),
        endDate: Date = Calendar.current.date(from: DateComponents(year: 2027, month: 8, day: 31)) ?? Date(),
        isCurrent: Bool = true,
        motivationalQuote: String = "Hai ancora molto da costruire.",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.isCurrent = isCurrent
        self.motivationalQuote = motivationalQuote
        self.createdAt = createdAt
    }
    
    var completedGoalsCount: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    var inProgressGoalsCount: Int {
        goals.filter { !$0.isCompleted }.count
    }
    
    var overallProgress: Double {
        guard !goals.isEmpty else { return 0.0 }
        let totalProgress = goals.reduce(0.0) { $0 + $1.progressPercentage }
        return totalProgress / Double(goals.count)
    }
    
    var formattedDateRange: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "it_IT")
        formatter.dateFormat = "MMMM yyyy"
        let start = formatter.string(from: startDate).capitalized
        let end = formatter.string(from: endDate).capitalized
        return "\(start) → \(end)"
    }
}
