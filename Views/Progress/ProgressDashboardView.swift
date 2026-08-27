import SwiftUI
import SwiftData

struct ProgressDashboardView: View {
    @Query private var allGoals: [Goal]
    
    var completedGoals: Int {
        allGoals.filter { $0.isCompleted }.count
    }
    
    var inProgressGoals: Int {
        allGoals.filter { !$0.isCompleted && $0.progressPercentage > 0 }.count
    }
    
    var notStartedGoals: Int {
        allGoals.filter { !$0.isCompleted && $0.progressPercentage == 0 }.count
    }
    
    var categoriesWithStats: [(name: String, emoji: String, hexColor: String, progress: Double)] {
        let categoryMap = Dictionary(grouping: allGoals, by: { $0.categoryName })
        return categoryMap.map { (catName, goals) in
            let emoji = goals.first?.categoryEmoji ?? "⭐"
            let hexColor = goals.first?.categoryColorHex ?? "#C3B1E1"
            let totalProg = goals.reduce(0.0) { $0 + $1.progressPercentage }
            let avgProg = goals.isEmpty ? 0.0 : totalProg / Double(goals.count)
            return (catName, emoji, hexColor, avgProg)
        }.sorted(by: { $0.progress > $1.progress })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Overview
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Panoramica dell'Anno")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.pastelTextDark)
                        
                        HStack(spacing: 12) {
                            StatCard(title: "Completati", count: completedGoals, color: .pastelSage)
                            StatCard(title: "In corso", count: inProgressGoals, color: .pastelPowderBlue)
                            StatCard(title: "Non iniziati", count: notStartedGoals, color: .pastelBlushPink)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Category Distribution Bars
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Progresso per Categoria")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.pastelTextDark)
                        
                        if categoriesWithStats.isEmpty {
                            Text("Nessun dato ancora disponibile")
                                .font(.subheadline)
                                .foregroundColor(.pastelTextMuted)
                                .pastelCard()
                        } else {
                            VStack(spacing: 16) {
                                ForEach(categoriesWithStats, id: \.name) { cat in
                                    VStack(alignment: .leading, spacing: 6) {
                                        HStack {
                                            Text("\(cat.emoji) \(cat.name)")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundColor(.pastelTextDark)
                                            
                                            Spacer()
                                            
                                            Text("\(Int(cat.progress * 100))%")
                                                .font(.subheadline)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(hex: cat.hexColor))
                                        }
                                        
                                        GeometryReader { geo in
                                            ZStack(alignment: .leading) {
                                                Capsule()
                                                    .fill(Color.pastelTextMuted.opacity(0.15))
                                                    .frame(height: 10)
                                                
                                                Capsule()
                                                    .fill(Color(hex: cat.hexColor))
                                                    .frame(width: geo.size.width * CGFloat(cat.progress), height: 10)
                                            }
                                        }
                                        .frame(height: 10)
                                    }
                                }
                            }
                            .pastelCard()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(Color.pastelCream.ignoresSafeArea())
            .navigationTitle("Progressi")
        }
    }
}

struct StatCard: View {
    var title: String
    var count: Int
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(count)")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(.pastelTextDark)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.pastelTextMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.2))
        .cornerRadius(16)
    }
}
