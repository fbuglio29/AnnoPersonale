import SwiftUI
import SwiftData

struct GoalsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allGoals: [Goal]
    
    @State private var selectedTab: Int = 0 // 0: In corso, 1: Completati, 2: Tutti
    @State private var selectedCategory: String? = nil
    @State private var showingAddSheet = false
    @State private var searchText = ""
    
    var categories: [String] {
        Array(Set(allGoals.map { $0.categoryName })).sorted()
    }
    
    var filteredGoals: [Goal] {
        allGoals.filter { goal in
            if selectedTab == 0 && goal.isCompleted { return false }
            if selectedTab == 1 && !goal.isCompleted { return false }
            if let cat = selectedCategory, goal.categoryName != cat { return false }
            if !searchText.isEmpty && !goal.title.localizedCaseInsensitiveContains(searchText) { return false }
            return true
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Status Segmented Control
                Picker("Stato", selection: $selectedTab) {
                    Text("In corso").tag(0)
                    Text("Completati").tag(1)
                    Text("Tutti").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Category Pills Carousel
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Button(action: { selectedCategory = nil }) {
                            Text("Tutte")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(selectedCategory == nil ? Color.pastelSage : Color.white)
                                .foregroundColor(selectedCategory == nil ? .white : .pastelTextDark)
                                .cornerRadius(20)
                        }
                        
                        ForEach(categories, id: \.self) { cat in
                            let sampleGoal = allGoals.first(where: { $0.categoryName == cat })
                            Button(action: {
                                if selectedCategory == cat {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = cat
                                }
                            }) {
                                CategoryBadge(
                                    emoji: sampleGoal?.categoryEmoji ?? "⭐",
                                    name: cat,
                                    hexColor: sampleGoal?.categoryColorHex ?? "#D3D3D3",
                                    isSelected: selectedCategory == cat
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Goals List
                if filteredGoals.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "checklist")
                            .font(.system(size: 48))
                            .foregroundColor(.pastelTextMuted.opacity(0.6))
                        Text("Nessun obiettivo trovato")
                            .font(.headline)
                            .foregroundColor(.pastelTextMuted)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredGoals) { goal in
                            ZStack {
                                NavigationLink(destination: GoalDetailView(goal: goal)) {
                                    EmptyView()
                                }
                                .opacity(0)
                                
                                GoalCardView(goal: goal, onToggleGoal: {
                                    try? modelContext.save()
                                })
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    modelContext.delete(goal)
                                    try? modelContext.save()
                                } label: {
                                    Label("Elimina", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color.pastelCream.ignoresSafeArea())
            .navigationTitle("I miei Obiettivi")
            .searchable(text: $searchText, prompt: "Cerca obiettivo...")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddSheet = true }) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .foregroundColor(.pastelSage)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                AddEditGoalView()
            }
        }
    }
}
