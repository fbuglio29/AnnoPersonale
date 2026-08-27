import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(filter: #Predicate<PersonalYearCycle> { $0.isCurrent }) private var cycles: [PersonalYearCycle]
    @ObservedObject private var notificationManager = NotificationManager.shared
    
    @State private var userName: String = "Utente"
    @State private var notificationsEnabled: Bool = false
    @State private var hapticsEnabled: Bool = true
    @State private var showingResetAlert = false
    
    var activeCycle: PersonalYearCycle? {
        cycles.first
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Profilo Personale")) {
                    HStack(spacing: 14) {
                        Circle()
                            .fill(Color.pastelSage.opacity(0.3))
                            .frame(width: 50, height: 50)
                            .overlay(
                                Text(userName.prefix(1).uppercased())
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pastelSage)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            TextField("Il tuo nome", text: $userName)
                                .font(.headline)
                            Text("Anno Personale Attivo")
                                .font(.caption)
                                .foregroundColor(.pastelTextMuted)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section(header: Text("Ciclo Attuale")) {
                    HStack {
                        Text("Titolo Ciclo")
                        Spacer()
                        Text(activeCycle?.title ?? "Nessuno")
                            .foregroundColor(.pastelTextMuted)
                    }
                    HStack {
                        Text("Data Inizio")
                        Spacer()
                        Text(activeCycle?.startDate.formatted(date: .abbreviated, time: .omitted) ?? "-")
                            .foregroundColor(.pastelTextMuted)
                    }
                    HStack {
                        Text("Data Fine")
                        Spacer()
                        Text(activeCycle?.endDate.formatted(date: .abbreviated, time: .omitted) ?? "-")
                            .foregroundColor(.pastelTextMuted)
                    }
                }
                
                Section(header: Text("Preferenze & Notifiche")) {
                    Toggle("Notifiche e Promemoria", isOn: $notificationsEnabled)
                        .onChange(of: notificationsEnabled) { newValue in
                            if newValue {
                                notificationManager.requestAuthorization { granted in
                                    if granted {
                                        notificationManager.scheduleWeeklyDigest()
                                    }
                                }
                            }
                        }
                    
                    Toggle("Feedback Tattile (Haptics)", isOn: $hapticsEnabled)
                }
                
                Section(header: Text("Gestione Dati & Privacy")) {
                    HStack {
                        Image(systemName: "lock.shield")
                            .foregroundColor(.pastelSage)
                        Text("Dati memorizzati 100% in locale")
                            .font(.caption)
                            .foregroundColor(.pastelTextMuted)
                    }
                    
                    Button("Esporta Dati in JSON") {
                        // JSON Export action
                    }
                    .foregroundColor(.pastelSage)
                    
                    Button(role: .destructive, action: { showingResetAlert = true }) {
                        Text("Elimina tutti i dati e ripristina")
                    }
                }
            }
            .navigationTitle("Profilo & Impostazioni")
            .alert("Ripristina Dati", isPresented: $showingResetAlert) {
                Button("Annulla", role: .cancel) {}
                Button("Ripristina", role: .destructive) {
                    try? modelContext.delete(model: Goal.self)
                    try? modelContext.delete(model: PersonalYearCycle.self)
                    try? modelContext.save()
                }
            } message: {
                Text("Sei sicuro di voler eliminare tutti gli obiettivi e il tuo anno personale?")
            }
        }
    }
}
