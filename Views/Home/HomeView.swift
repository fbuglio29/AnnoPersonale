import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(filter: #Predicate<PersonalYearCycle> { $0.isCurrent }) private var cycles: [PersonalYearCycle]
    @Query private var allGoals: [Goal]
    @State private var showingAddGoalSheet = false
    @State private var confettiTrigger = false
    
    var activeCycle: PersonalYearCycle? {
        cycles.first
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Cycle Header
                    VStack(spacing: 6) {
                        Text("Il mio anno")
                            .font(.caption)
                            .fontWeight(.bold)
                            .textCase(.uppercase)
                            .foregroundColor(.pastelSage)
                        
                        Text(activeCycle?.title ?? "Settembre 2026 → Agosto 2027")
                            .font(.system(size: 22, weight: .bold, design: .serif))
                            .foregroundColor(.pastelTextDark)
                        
                        Text("“\(activeCycle?.motivationalQuote ?? "Hai ancora molto da costruire.")”")
                            .font(.subheadline)
                            .italic()
                            .foregroundColor(.pastelTextMuted)
                            .padding(.top, 2)
                    }
                    .padding(.top, 8)
                    
                    // Circular Progress Card
                    VStack(spacing: 16) {
                        CircularProgressView(
                            progress: activeCycle?.overallProgress ?? 0.42,
                            lineWidth: 18,
                            size: 170,
                            accentColor: .pastelSage
                        )
                        
                        // Summary Counters
                        HStack(spacing: 24) {
                            StatCounterView(count: allGoals.count, label: "obiettivi")
                            Divider().frame(height: 30)
                            StatCounterView(count: allGoals.filter { $0.isCompleted }.count, label: "completati")
                            Divider().frame(height: 30)
                            StatCounterView(count: allGoals.filter { !$0.isCompleted }.count, label: "in corso")
                        }
                        .padding(.top, 8)
                    }
                    .pastelCard()
                    .padding(.horizontal)
                    
                    // Priority / Highlighted Goals Section
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("Obiettivi in evidenza")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.pastelTextDark)
                            
                            Spacer()
                            
                            NavigationLink(destination: GoalsListView()) {
                                Text("Vedi tutti")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.pastelSage)
                            }
                        }
                        
                        let highlightedGoals = Array(allGoals.prefix(4))
                        if highlightedGoals.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "sparkles")
                                    .font(.largeTitle)
                                    .foregroundColor(.pastelSage)
                                Text("Nessun obiettivo ancora inserito")
                                    .font(.subheadline)
                                    .foregroundColor(.pastelTextMuted)
                                Button(action: { showingAddGoalSheet = true }) {
                                    Text("Crea il tuo primo obiettivo")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color.pastelSage)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 24)
                            .pastelCard()
                        } else {
                            ForEach(highlightedGoals) { goal in
                                NavigationLink(destination: GoalDetailView(goal: goal)) {
                                    GoalCardView(goal: goal, onToggleGoal: {
                                        if goal.isCompleted {
                                            confettiTrigger = true
                                        }
                                    })
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 32)
            }
            .background(Color.pastelCream.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddGoalSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.pastelSage)
                    }
                }
            }
            .sheet(isPresented: $showingAddGoalSheet) {
                AddEditGoalView()
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
    }
}

struct StatCounterView: View {
    var count: Int
    var label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text("\(count)")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.pastelTextDark)
            Text(label)
                .font(.caption2)
                .foregroundColor(.pastelTextMuted)
        }
    }
}
