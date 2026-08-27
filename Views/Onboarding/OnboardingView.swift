import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isOnboardingComplete: Bool
    
    @State private var selectedCycleType: String = "september" // september, january, custom
    @State private var customStartDate: Date = Date()
    @State private var customEndDate: Date = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            
            // Header Title
            VStack(spacing: 12) {
                Text("🌿")
                    .font(.system(size: 64))
                
                Text("Un nuovo anno.\nA modo tuo.")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pastelTextDark)
                
                Text("Non serve aspettare gennaio.\nOgni settembre può essere un nuovo inizio.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.pastelTextMuted)
                    .padding(.horizontal, 24)
            }
            
            // Cycle Selection Card
            VStack(alignment: .leading, spacing: 16) {
                Text("Quando inizia il tuo nuovo anno?")
                    .font(.headline)
                    .foregroundColor(.pastelTextDark)
                
                VStack(spacing: 10) {
                    CycleOptionRow(
                        title: "Settembre (Consigliato)",
                        subtitle: "Settembre 2026 → Agosto 2027",
                        isSelected: selectedCycleType == "september",
                        action: { selectedCycleType = "september" }
                    )
                    
                    CycleOptionRow(
                        title: "Gennaio (Solare)",
                        subtitle: "Gennaio 2026 → Dicembre 2026",
                        isSelected: selectedCycleType == "january",
                        action: { selectedCycleType = "january" }
                    )
                    
                    CycleOptionRow(
                        title: "Data personalizzata",
                        subtitle: "Scegli tu il tuo intervallo perfetto",
                        isSelected: selectedCycleType == "custom",
                        action: { selectedCycleType = "custom" }
                    )
                }
                
                if selectedCycleType == "custom" {
                    VStack(spacing: 12) {
                        DatePicker("Inizio", selection: $customStartDate, displayedComponents: .date)
                        DatePicker("Fine", selection: $customEndDate, displayedComponents: .date)
                    }
                    .padding()
                    .background(Color.pastelCream)
                    .cornerRadius(12)
                }
            }
            .pastelCard()
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Start Button
            Button(action: createCycleAndFinish) {
                Text("Inizia il tuo anno")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.pastelSage)
                    .cornerRadius(16)
                    .shadow(color: Color.pastelSage.opacity(0.4), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(Color.pastelCream.ignoresSafeArea())
    }
    
    private func createCycleAndFinish() {
        var start: Date
        var end: Date
        var title: String
        
        let now = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: now)
        
        if selectedCycleType == "september" {
            start = calendar.date(from: DateComponents(year: currentYear, month: 9, day: 1)) ?? now
            end = calendar.date(from: DateComponents(year: currentYear + 1, month: 8, day: 31)) ?? now
            title = "Settembre \(currentYear) → Agosto \(currentYear + 1)"
        } else if selectedCycleType == "january" {
            start = calendar.date(from: DateComponents(year: currentYear, month: 1, day: 1)) ?? now
            end = calendar.date(from: DateComponents(year: currentYear, month: 12, day: 31)) ?? now
            title = "Gennaio \(currentYear) → Dicembre \(currentYear)"
        } else {
            start = customStartDate
            end = customEndDate
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM yyyy"
            title = "\(formatter.string(from: start)) → \(formatter.string(from: end))"
        }
        
        let cycle = PersonalYearCycle(
            title: title,
            startDate: start,
            endDate: end,
            isCurrent: true,
            motivationalQuote: "Hai ancora molto da costruire."
        )
        
        modelContext.insert(cycle)
        SampleData.createSampleCycle(context: modelContext)
        
        withAnimation {
            isOnboardingComplete = true
        }
    }
}

struct CycleOptionRow: View {
    var title: String
    var subtitle: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.pastelTextDark)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.pastelTextMuted)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.pastelSage : Color.pastelTextMuted.opacity(0.3), lineWidth: 2)
                        .frame(width: 22, height: 22)
                    if isSelected {
                        Circle()
                            .fill(Color.pastelSage)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.pastelSage.opacity(0.1) : Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.pastelSage : Color.black.opacity(0.04), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
