import SwiftUI
import SwiftData

struct MainTabView: View {
    @Query(filter: #Predicate<PersonalYearCycle> { $0.isCurrent }) private var activeCycles: [PersonalYearCycle]
    @State private var isOnboardingComplete: Bool = true
    
    var body: some View {
        Group {
            if activeCycles.isEmpty {
                OnboardingView(isOnboardingComplete: $isOnboardingComplete)
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                    
                    GoalsListView()
                        .tabItem {
                            Label("Obiettivi", systemImage: "target")
                        }
                    
                    ProgressDashboardView()
                        .tabItem {
                            Label("Progressi", systemImage: "chart.bar.fill")
                        }
                    
                    TimelineView()
                        .tabItem {
                            Label("Timeline", systemImage: "calendar")
                        }
                    
                    YearReviewView()
                        .tabItem {
                            Label("Revisione", systemImage: "sparkles")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Profilo", systemImage: "person.crop.circle")
                        }
                }
                .tint(Color.pastelSage)
            }
        }
    }
}
