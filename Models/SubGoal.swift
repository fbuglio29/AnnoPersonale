import Foundation
import SwiftData

@Model
final class SubGoal {
    var id: UUID
    var title: String
    var isCompleted: Bool
    var completedAt: Date?
    var orderIndex: Int
    
    @Relationship(inverse: \Goal.subgoals)
    var parentGoal: Goal?
    
    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        completedAt: Date? = nil,
        orderIndex: Int = 0
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.completedAt = completedAt
        self.orderIndex = orderIndex
    }
}
