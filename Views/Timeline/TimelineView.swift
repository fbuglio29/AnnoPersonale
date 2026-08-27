import SwiftUI
import SwiftData

struct TimelineView: View {
    @Query private var allGoals: [Goal]
    
    // Personal Year Months sequence (September -> August)
    let monthsOrder = [
        (num: 9, name: "SETTEMBRE"),
        (num: 10, name: "OTTOBRE"),
        (num: 11, name: "NOVEMBRE"),
        (num: 12, name: "DICEMBRE"),
        (num: 1, name: "GENNAIO"),
        (num: 2, name: "FEBBRAIO"),
        (num: 3, name: "MARZO"),
        (num: 4, name: "APRILE"),
        (num: 5, name: "MAGGIO"),
        (num: 6, name: "GIUGNO"),
        (num: 7, name: "LUGLIO"),
        (num: 8, name: "AGOSTO")
    ]
    
    @State private var selectedMonthNum: Int = 9
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Horizontal Month Selector
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(monthsOrder, id: \.num) { m in
                            Button(action: {
                                withAnimation {
                                    selectedMonthNum = m.num
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Text(m.name.prefix(3))
                                        .font(.caption)
                                        .fontWeight(.bold)
                                    
                                    let monthGoalsCount = allGoals.filter { $0.targetMonth == m.num }.count
                                    Circle()
                                        .fill(monthGoalsCount > 0 ? Color.pastelSage : Color.clear)
                                        .frame(width: 5, height: 5)
                                }
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(selectedMonthNum == m.num ? Color.pastelSage : Color.white)
                                .foregroundColor(selectedMonthNum == m.num ? .white : .pastelTextDark)
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.pastelCream)
                
                // Goals List for selected month
                let currentMonthName = monthsOrder.first(where: { $0.num == selectedMonthNum })?.name ?? ""
                let goalsForMonth = allGoals.filter { $0.targetMonth == selectedMonthNum }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text(currentMonthName)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.pastelTextDark)
                            
                            Spacer()
                            
                            Text("\(goalsForMonth.count) obiettivi")
                                .font(.caption)
                                .foregroundColor(.pastelTextMuted)
                        }
                        .padding(.horizontal)
                        
                        if goalsForMonth.isEmpty {
                            VStack(spacing: 12) {
                                Image(systemName: "calendar.badge.clock")
                                    .font(.system(size: 40))
                                    .foregroundColor(.pastelTextMuted.opacity(0.5))
                                Text("Nessun obiettivo pianificato per questo mese")
                                    .font(.subheadline)
                                    .foregroundColor(.pastelTextMuted)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .pastelCard()
                            .padding(.horizontal)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(goalsForMonth) { goal in
                                    NavigationLink(destination: GoalDetailView(goal: goal)) {
                                        GoalCardView(goal: goal, onToggleGoal: {})
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color.pastelCream.ignoresSafeArea())
            }
            .navigationTitle("Timeline dell'Anno")
        }
    }
}
