import Foundation
import Combine

/// Person 3: Manages customize checklist view state and actions.
/// Fully offline-capable: add/toggle/delete items are queued when offline
/// and flushed to the backend automatically when connectivity is restored.
@MainActor
final class CustomizeChecklistViewModel: ObservableObject {

    // MARK: - Form Fields
    @Published var itemName: String = ""
    @Published var selectedCategory: KitCategory = .lighting
    @Published var quantity: Int = 1
    @Published var priority: ChecklistPriority = .high
    @Published var disasterType: String = "Flood"

    // MARK: - State
    @Published var isOffline: Bool = false
    @Published var pendingCount: Int = 0
    @Published var showOfflineBanner: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String? = nil

    // Live item list — mirrors PreparednessViewModel.emergencyKit
    @Published var customItems: [ChecklistItem] = []

    let categories = KitCategory.allCases
    let disasterTypes = ["All", "Flood", "Earthquake", "Tsunami", "Volcano", "Wildfire"]

    // MARK: - Dependencies
    private var preparednessVM: PreparednessViewModel?
    private let queue = PendingChecklistQueue.shared
    private let networkMonitor = NetworkMonitor.shared
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Placeholder (used before EnvironmentObject is available)

    /// A lightweight placeholder VM used only so @StateObject can be created before
    /// the EnvironmentObject is injected via syncWith(_:).
    static var _placeholder: CustomizeChecklistViewModel {
        CustomizeChecklistViewModel()
    }

    // MARK: - Init

    init() {
        setupNetworkObserver()
    }

    // MARK: - Wiring

    /// Called from the View's .onAppear to inject the shared PreparednessViewModel.
    func syncWith(_ vm: PreparednessViewModel) {
        guard preparednessVM == nil else { return } // only wire once
        self.preparednessVM = vm

        // Mirror the item list from the shared VM
        vm.$emergencyKit
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                self?.customItems = items
            }
            .store(in: &cancellables)

        // Seed immediately
        customItems = vm.emergencyKit
        pendingCount = queue.pendingCount()
    }

    // MARK: - Network Observer

    private func setupNetworkObserver() {
        networkMonitor.$isConnected
            .map { !$0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] offline in
                self?.isOffline = offline
                self?.showOfflineBanner = offline
                self?.pendingCount = PendingChecklistQueue.shared.pendingCount()
            }
            .store(in: &cancellables)

        isOffline = !networkMonitor.isConnected
        showOfflineBanner = isOffline
    }

    // MARK: - Save Item (Add)

    /// Add a new item. Works offline — the item is immediately visible in the
    /// shared list and the create operation is queued for backend sync.
    func saveItem() {
        guard !itemName.isEmpty, let vm = preparednessVM else { return }
        isSaving = true

        let newItem = ChecklistItem(
            id: UUID().uuidString,
            name: itemName,
            isChecked: false,
            category: selectedCategory,
            quantity: quantity,
            priority: priority,
            disasterType: disasterType
        )

        Task {
            await vm.addItem(newItem)
            await MainActor.run {
                self.isSaving = false
                self.resetForm()
                self.pendingCount = self.queue.pendingCount()
            }
        }
    }

    // MARK: - Toggle Item

    /// Toggle the checked state. Works offline.
    func toggleItem(_ item: ChecklistItem) {
        guard let vm = preparednessVM else { return }
        Task {
            await vm.toggleItem(item)
            await MainActor.run {
                self.pendingCount = self.queue.pendingCount()
            }
        }
    }

    // MARK: - Delete Item

    func deleteItem(id: String) {
        guard let vm = preparednessVM else { return }
        Task {
            await vm.deleteItem(id: id)
            await MainActor.run {
                self.pendingCount = self.queue.pendingCount()
            }
        }
    }

    // MARK: - Reset Form

    func resetForm() {
        itemName = ""
        quantity = 1
        selectedCategory = .lighting
        priority = .high
        disasterType = "Flood"
        errorMessage = nil
    }
}
