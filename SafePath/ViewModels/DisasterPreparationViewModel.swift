import Foundation
import Combine

@MainActor
final class DisasterPreparationViewModel: ObservableObject {
    
    @Published var guides: [DisasterPreparationGuide] = []
    @Published var checklistItems: [ChecklistItem] = []
    
    private let prepRepository: DisasterPreparationRepositoryProtocol
    private let checklistRepository: ChecklistRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        prepRepository: DisasterPreparationRepositoryProtocol = DisasterPreparationRepository(),
        checklistRepository: ChecklistRepositoryProtocol = ChecklistRepository()
    ) {
        self.prepRepository = prepRepository
        self.checklistRepository = checklistRepository
        loadGuides()
    }
    
    func loadGuides() {
        prepRepository.fetchGuides()
            .receive(on: RunLoop.main)
            .sink { _ in } receiveValue: { [weak self] fetchedGuides in
                self?.guides = fetchedGuides
            }
            .store(in: &cancellables)
    }
    
    func loadChecklist(for disasterType: String) {
        checklistRepository.fetchItems(forDisasterType: disasterType)
            .receive(on: RunLoop.main)
            .sink { _ in } receiveValue: { [weak self] items in
                self?.checklistItems = items
            }
            .store(in: &cancellables)
    }
    
    func toggleChecklistItem(_ item: ChecklistItem) {
        var updatedItem = item
        updatedItem.isChecked.toggle()
        
        checklistRepository.saveCustomItem(updatedItem)
            .receive(on: RunLoop.main)
            .sink { _ in } receiveValue: { [weak self] _ in
                // Reload checklist to reflect the change
                if let disasterType = self?.checklistItems.first(where: { $0.id == updatedItem.id })?.disasterType {
                    self?.loadChecklist(for: disasterType)
                }
            }
            .store(in: &cancellables)
    }
}

//
