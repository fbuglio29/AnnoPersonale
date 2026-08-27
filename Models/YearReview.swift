import Foundation
import SwiftData

@Model
final class YearReview {
    var id: UUID
    var cycleTitle: String
    var completedGoalsCount: Int
    var totalGoalsCount: Int
    var progressPercentage: Double
    var carryForwardText: String
    var leaveBehindText: String
    var topCategories: [String]
    var createdAt: Date
    
    @Relationship(inverse: \PersonalYearCycle.reviews)
    var yearCycle: PersonalYearCycle?
    
    init(
        id: UUID = UUID(),
        cycleTitle: String,
        completedGoalsCount: Int,
        totalGoalsCount: Int,
        progressPercentage: Double,
        carryForwardText: String = "",
        leaveBehindText: String = "",
        topCategories: [String] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.cycleTitle = cycleTitle
        self.completedGoalsCount = completedGoalsCount
        self.totalGoalsCount = totalGoalsCount
        self.progressPercentage = progressPercentage
        self.carryForwardText = carryForwardText
        self.leaveBehindText = leaveBehindText
        self.topCategories = topCategories
        self.createdAt = createdAt
    }
}
