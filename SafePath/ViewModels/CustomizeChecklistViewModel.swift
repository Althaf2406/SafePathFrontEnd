import Foundation
import Combine

/// Person 3: Manages customize checklist view state and actions.
@MainActor
final class CustomizeChecklistViewModel: ObservableObject {
    
    @Published var itemName: String = ""
    @Published var selectedCategory: KitCategory = .lighting
    @Published var quantity: Int = 1
    @Published var priority: ChecklistPriority = .high
    @Published var disasterType: String = "Flood"
    
    @Published var customItems: [ChecklistItem] = []
    
    private let repository = ChecklistRepository()
    private var cancellables = Set<AnyCancellable>()
    
    let categories = KitCategory.allCases
    let disasterTypes = ["All", "Flood", "Earthquake", "Tsunami", "Volcano", "Wildfire"]
    
    init() {
        loadCustomItems()
    }
    
    func loadCustomItems() {
        repository.fetchCustomItems()
            .receive(on: RunLoop.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print("Error fetching custom items: \(error)")
                }
            } receiveValue: { [weak self] items in
                self?.customItems = items
            }
            .store(in: &cancellables)
    }
    
    func saveItem() {
        guard !itemName.isEmpty else { return }
        
        let newItem = ChecklistItem(
            id: UUID().uuidString,
            name: itemName,
            isChecked: false,
            category: selectedCategory,
            quantity: quantity,
            priority: priority,
            disasterType: disasterType
        )
        
        repository.saveCustomItem(newItem)
            .receive(on: RunLoop.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.loadCustomItems()
                self?.resetForm()
            }
            .store(in: &cancellables)
    }
    
    func deleteItem(id: String) {
        repository.deleteCustomItem(id: id)
            .receive(on: RunLoop.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                self?.loadCustomItems()
            }
            .store(in: &cancellables)
    }
    
    func resetForm() {
        itemName = ""
        quantity = 1
    }
}
