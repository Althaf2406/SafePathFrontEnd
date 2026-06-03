import Combine
import Foundation

@MainActor
final class PreparednessViewModel: ObservableObject {

    // MARK: - Published State

    @Published var emergencyKit: [ChecklistItem] = []
    @Published var riskProfiles: [RiskProfile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: PreparednessRepository

    init(repository: PreparednessRepository = PreparednessRepository()) {
        self.repository = repository
    }

    // MARK: - Load

    func load() async {
        isLoading = true
        defer { isLoading = false }
        await getAllItem()
        await loadRiskProfiles()
    }

    func getAllItem() async {
        do {
            let items = try await repository.getAllItem()
            self.emergencyKit = items
        } catch {
            // Fall back to mock data when backend is not available
            self.emergencyKit = Self.mockKitItems
        }
    }

    func loadRiskProfiles() async {
        do {
            let profiles = try await repository.fetchRiskProfiles()
            self.riskProfiles = profiles
        } catch {
            // Fall back to mock risk profiles
            self.riskProfiles = Self.mockRiskProfiles
        }
    }

    // MARK: - CRUD

    /// Toggle isChecked status and sync to backend.
    func toggleItem(_ item: ChecklistItem) async {
        // Optimistic update — update local state immediately
        guard let index = emergencyKit.firstIndex(where: { $0.id == item.id }) else { return }
        emergencyKit[index].isChecked.toggle()

        let updatedItem = emergencyKit[index]
        do {
            let saved = try await repository.updateItem(updatedItem)
            emergencyKit[index] = saved
        } catch {
            // Rollback on failure
            emergencyKit[index].isChecked = item.isChecked
            errorMessage = "Failed to update item."
        }
    }

    /// Add a new item to the kit and sync to backend.
    func addItem(_ item: ChecklistItem) async {
        do {
            let saved = try await repository.createItem(item)
            emergencyKit.insert(saved, at: 0)
        } catch {
            errorMessage = "Failed to add item."
        }
    }

    /// Delete an item from the kit and sync to backend.
    func deleteItem(id: String) async {
        do {
            try await repository.deleteItem(id: id)
            emergencyKit.removeAll { $0.id == id }
        } catch {
            errorMessage = "Failed to delete item."
        }
    }

    // MARK: - Computed

    var overallReadiness: Double {
        guard !emergencyKit.isEmpty else { return 0 }
        return Double(emergencyKit.filter { $0.isChecked }.count) / Double(emergencyKit.count)
    }

    var completedItemsCount: Int {
        emergencyKit.filter { $0.isChecked }.count
    }

    var totalItemsCount: Int {
        emergencyKit.count
    }

    var kitCategory: [KitCategory: [ChecklistItem]] {
        Dictionary(grouping: emergencyKit, by: { $0.category })
    }

    // MARK: - Mock Fallback Data

    private static let mockKitItems: [ChecklistItem] = [
        ChecklistItem(id: UUID().uuidString, name: "First Aid Kit",        isChecked: true,  category: .firstAid,     quantity: 1, priority: .high,   disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Water (3L/person/day)",isChecked: true,  category: .water,        quantity: 3, priority: .high,   disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Flashlight & Batteries",isChecked: false, category: .lighting,    quantity: 1, priority: .medium, disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Emergency Food (3 days)",isChecked: false,category: .food,         quantity: 3, priority: .high,   disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Whistle",              isChecked: false, category: .communication, quantity: 1, priority: .medium, disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Copies of Documents",  isChecked: false, category: .documents,    quantity: 1, priority: .medium, disasterType: "All"),
    ]

    private static let mockRiskProfiles: [RiskProfile] = [
        RiskProfile(id: "1", type: "Earthquake", iconName: "waveform.path.ecg",    level: .high),
        RiskProfile(id: "2", type: "Flood",      iconName: "cloud.heavyrain.fill",  level: .medium),
        RiskProfile(id: "3", type: "Tsunami",    iconName: "water.waves",           level: .low),
    ]
}
