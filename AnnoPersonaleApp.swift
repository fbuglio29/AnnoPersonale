import SwiftUI
import SwiftData

@main
struct AnnoPersonaleApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PersonalYearCycle.self,
            Goal.self,
            SubGoal.self,
            GoalCategory.self,
            YearReview.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Impossibile creare ModelContainer SwiftData: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
