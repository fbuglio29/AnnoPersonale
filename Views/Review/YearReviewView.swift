import SwiftUI
import SwiftData

struct YearReviewView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<PersonalYearCycle> { $0.isCurrent }) private var activeCycles: [PersonalYearCycle]
    @Query private var allGoals: [Goal]
    
    @State private var carryForwardNotes: String = ""
    @State private var leaveBehindNotes: String = ""
    @State private var showingNewYearModal: Bool = false
    
    var cycle: PersonalYearCycle? {
        activeCycles.first
    }
    
    var completedGoals: [Goal] {
        allGoals.filter { $0.isCompleted }
    }
    
    var pendingGoals: [Goal] {
        allGoals.filter { !$0.isCompleted }
    }
    
    var completionRatePercentage: Int {
        guard !allGoals.isEmpty else { return 0 }
        return Int((Double(completedGoals.count) / Double(allGoals.count)) * 100)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Banner
                    VStack(spacing: 8) {
                        Text("✨ LA MIA REVISIONE ✨")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.pastelSage)
                        
                        Text("Il tuo anno in sintesi")
                            .font(.system(size: 26, weight: .bold, design: .serif))
                            .foregroundColor(.pastelTextDark)
                        
                        Text(cycle?.title ?? "Settembre 2026 → Agosto 2027")
                            .font(.subheadline)
                            .foregroundColor(.pastelTextMuted)
                    }
                    .padding(.top, 8)
                    
                    // Main Stats Card
                    VStack(spacing: 16) {
                        Text("\(completionRatePercentage)%")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.pastelSage)
                        
                        Text("Hai completato **\(completedGoals.count)** obiettivi su **\(allGoals.count)**")
                            .font(.body)
                            .foregroundColor(.pastelTextDark)
                            .multilineTextAlignment(.center)
                    }
                    .pastelCard()
                    .padding(.horizontal)
                    
                    // Ritual Reflection Inputs
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("🌱")
                                Text("Cosa voglio portare con me nel prossimo anno?")
                                    .font(.headline)
                                    .foregroundColor(.pastelTextDark)
                            }
                            TextEditor(text: $carryForwardNotes)
                                .frame(height: 90)
                                .padding(8)
                                .background(Color.pastelCream)
                                .cornerRadius(12)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("🍂")
                                Text("Cosa voglio lasciare indietro?")
                                    .font(.headline)
                                    .foregroundColor(.pastelTextDark)
                            }
                            TextEditor(text: $leaveBehindNotes)
                                .frame(height: 90)
                                .padding(8)
                                .background(Color.pastelCream)
                                .cornerRadius(12)
                        }
                    }
                    .pastelCard()
                    .padding(.horizontal)
                    
                    // Completed Goals Highlights
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Obiettivi Raggiunti 🎉")
                            .font(.headline)
                            .foregroundColor(.pastelTextDark)
                        
                        if completedGoals.isEmpty {
                            Text("Nessun obiettivo ancora completato")
                                .font(.subheadline)
                                .foregroundColor(.pastelTextMuted)
                        } else {
                            ForEach(completedGoals) { goal in
                                HStack {
                                    Text(goal.categoryEmoji)
                                    Text(goal.title)
                                        .font(.body)
                                        .foregroundColor(.pastelTextDark)
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.pastelSage)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .pastelCard()
                    .padding(.horizontal)
                    
                    // Transition Button
                    Button(action: { showingNewYearModal = true }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("È iniziato un nuovo anno")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.pastelSage)
                        .cornerRadius(16)
                        .shadow(color: Color.pastelSage.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(Color.pastelCream.ignoresSafeArea())
            .navigationTitle("Revisione dell'Anno")
            .sheet(isPresented: $showingNewYearModal) {
                NewYearTransitionView()
            }
        }
    }
}

struct NewYearTransitionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var currentGoals: [Goal]
    
    @State private var carryOverIncomplete = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()
                
                Text("🌟")
                    .font(.system(size: 64))
                
                Text("Inizia un nuovo ciclo")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundColor(.pastelTextDark)
                
                Text("Hai completato una tappa fondamentale del tuo percorso personale. Ora puoi progettare il tuo prossimo anno.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pastelTextMuted)
                    .padding(.horizontal, 24)
                
                VStack(alignment: .leading, spacing: 14) {
                    Toggle("Trasferisci gli obiettivi non completati al nuovo anno", isOn: $carryOverIncomplete)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.pastelTextDark)
                }
                .pastelCard()
                .padding(.horizontal, 24)
                
                Spacer()
                
                Button(action: startNewYear) {
                    Text("Crea nuovo ciclo personale")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.pastelSage)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(Color.pastelCream.ignoresSafeArea())
        }
    }
    
    private func startNewYear() {
        if !carryOverIncomplete {
            for goal in currentGoals where !goal.isCompleted {
                modelContext.delete(goal)
            }
        }
        try? modelContext.save()
        dismiss()
    }
}
