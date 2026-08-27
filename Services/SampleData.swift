import Foundation
import SwiftData

struct SampleData {
    static func createSampleCycle(context: ModelContext) {
        let cycle = PersonalYearCycle(
            title: "Settembre 2026 → Agosto 2027",
            startDate: Calendar.current.date(from: DateComponents(year: 2026, month: 9, day: 1))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2027, month: 8, day: 31))!,
            isCurrent: true,
            motivationalQuote: "Hai ancora molto da costruire."
        )
        context.insert(cycle)
        
        let goal1 = Goal(
            title: "Tornare in forma & Salute",
            goalDescription: "Sviluppare un'abitudine costante di movimento e nutrizione sana.",
            categoryName: "Salute & Sport",
            categoryEmoji: "🏋️",
            categoryColorHex: "#9CAF88",
            priority: .high,
            targetMonth: 9
        )
        let sub1_1 = SubGoal(title: "Allenarmi 3 volte a settimana", isCompleted: true)
        let sub1_2 = SubGoal(title: "Perdere 5 kg", isCompleted: true)
        let sub1_3 = SubGoal(title: "Correre 10 km", isCompleted: false)
        goal1.subgoals = [sub1_1, sub1_2, sub1_3]
        goal1.yearCycle = cycle
        
        let goal2 = Goal(
            title: "Risparmiare €5.000",
            goalDescription: "Creare un fondo d'emergenza e gestire le spese con consapevolezza.",
            categoryName: "Finanze",
            categoryEmoji: "💰",
            categoryColorHex: "#F4E0A5",
            priority: .high,
            targetMonth: 12
        )
        let sub2_1 = SubGoal(title: "Risparmiare €400 al mese", isCompleted: true)
        let sub2_2 = SubGoal(title: "Ridurre le spese inutili", isCompleted: true)
        let sub2_3 = SubGoal(title: "Creare un fondo emergenza", isCompleted: false)
        goal2.subgoals = [sub2_1, sub2_2, sub2_3]
        goal2.yearCycle = cycle
        
        let goal3 = Goal(
            title: "Visitare il Giappone",
            goalDescription: "Un viaggio sognato da tempo per esplorare Tokyo e Kyoto.",
            categoryName: "Viaggi",
            categoryEmoji: "✈️",
            categoryColorHex: "#98C1D9",
            priority: .medium,
            targetMonth: 6
        )
        let sub3_1 = SubGoal(title: "Stabilire il budget", isCompleted: true)
        let sub3_2 = SubGoal(title: "Prenotare il volo", isCompleted: false)
        let sub3_3 = SubGoal(title: "Prenotare hotel", isCompleted: false)
        let sub3_4 = SubGoal(title: "Organizzare itinerario", isCompleted: false)
        let sub3_5 = SubGoal(title: "Partire", isCompleted: false)
        goal3.subgoals = [sub3_1, sub3_2, sub3_3, sub3_4, sub3_5]
        goal3.yearCycle = cycle
        
        let goal4 = Goal(
            title: "Imparare l'inglese fluente",
            goalDescription: "Voglio riuscire a sostenere una conversazione senza difficoltà.",
            categoryName: "Crescita personale",
            categoryEmoji: "🧠",
            categoryColorHex: "#C3B1E1",
            priority: .high,
            targetMonth: 9
        )
        let sub4_1 = SubGoal(title: "Ascoltare podcast in lingua ogni giorno", isCompleted: true)
        let sub4_2 = SubGoal(title: "Leggere 3 libri in inglese", isCompleted: false)
        let sub4_3 = SubGoal(title: "Fare lezioni di conversazione weekly", isCompleted: false)
        goal4.subgoals = [sub4_1, sub4_2, sub4_3]
        goal4.yearCycle = cycle
        
        let goal5 = Goal(
            title: "Leggere 12 libri",
            goalDescription: "Un libro al mese per la crescita personale e il relax.",
            categoryName: "Studio",
            categoryEmoji: "📚",
            categoryColorHex: "#B5D2AD",
            priority: .low,
            targetMonth: 10
        )
        goal5.yearCycle = cycle
        
        context.insert(goal1)
        context.insert(goal2)
        context.insert(goal3)
        context.insert(goal4)
        context.insert(goal5)
        
        try? context.save()
    }
}
