import Combine
import Foundation

@MainActor
final class PreparednessViewModel: ObservableObject {

    // MARK: - Published State

    @Published var emergencyKit: [ChecklistItem] = []
    @Published var riskProfiles: [RiskProfile] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isOffline: Bool = false
    @Published var pendingCount: Int = 0

    private let repository: PreparednessRepositoryProtocol
    private let storage = LocalStorageService.shared
    private let queue = PendingChecklistQueue.shared
    private let networkMonitor = NetworkMonitor.shared

    // UserDefaults keys for caching
    private let cacheKey = "safepath.emergency_kit_cache"
    private let cacheTimestampKey = "safepath.emergency_kit_cache_timestamp"

    private var cancellables = Set<AnyCancellable>()

    init(repository: PreparednessRepositoryProtocol? = nil) {
        self.repository = repository ?? PreparednessRepository()
        observeNetwork()
    }

    // MARK: - Network Observer

    private func observeNetwork() {
        networkMonitor.$isConnected
            .removeDuplicates()
            .sink { [weak self] connected in
                guard let self else { return }
                self.isOffline = !connected
                if connected {
                    Task {
                        // Flush any pending offline operations first, then refresh
                        await self.flushPendingOperations()
                        await self.getAllItem()
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Load

    func load(lat: Double, lng: Double) async {
        isLoading = true
        defer { isLoading = false }
        await getAllItem()
        await loadRiskProfiles(lat: lat, lng: lng)
    }

    func getAllItem() async {
        // If offline, load from cache
        guard networkMonitor.isConnected else {
            loadFromCache()
            isOffline = true
            return
        }

        do {
            let items = try await repository.getAllItem()
            self.emergencyKit = items
            saveToCache(items)
            isOffline = false
        } catch {
            // Try cache first before falling back to mock
            if let cached: [ChecklistItem] = storage.load(forKey: cacheKey), !cached.isEmpty {
                self.emergencyKit = cached
                print("📦 [Cache] Loaded \(cached.count) item(s) from local cache (network error).")
            } else {
                self.emergencyKit = Self.mockKitItems
                print("⚠️ [Fallback] No cache available, using mock data.")
            }
        }
        pendingCount = queue.pendingCount()
    }

    func loadRiskProfiles(lat: Double, lng: Double) async {
        do {
            let profiles = try await repository.fetchRiskProfiles(lat: lat, lng: lng)
            self.riskProfiles = profiles
        } catch {
            // Fall back to mock risk profiles
            self.riskProfiles = Self.mockRiskProfiles
        }
    }

    // MARK: - CRUD (Offline-aware)

    /// Toggle isChecked status. Works offline: queues the change and syncs later.
    func toggleItem(_ item: ChecklistItem) async {
        // Optimistic update — update local state immediately
        guard let index = emergencyKit.firstIndex(where: { $0.id == item.id }) else { return }
        emergencyKit[index].isChecked.toggle()
        let updatedItem = emergencyKit[index]

        // Always save updated state to cache
        saveToCache(emergencyKit)

        if networkMonitor.isConnected {
            do {
                let saved = try await repository.updateItem(updatedItem)
                emergencyKit[index] = saved
                saveToCache(emergencyKit)
            } catch {
                // Rollback on network failure & queue
                emergencyKit[index].isChecked = item.isChecked
                saveToCache(emergencyKit)
                queueOperation(type: .toggle, item: updatedItem)
                errorMessage = "Offline: perubahan disimpan dan akan dikirim saat online."
            }
        } else {
            // Queue for later sync
            queueOperation(type: .toggle, item: updatedItem)
            errorMessage = "Offline: perubahan disimpan dan akan dikirim saat online."
        }
        pendingCount = queue.pendingCount()
    }

    /// Add a new item to the kit. Works offline: queues the creation and syncs later.
    func addItem(_ item: ChecklistItem) async {
        if networkMonitor.isConnected {
            do {
                let saved = try await repository.createItem(item)
                emergencyKit.insert(saved, at: 0)
                saveToCache(emergencyKit)
            } catch {
                // Save locally and queue
                emergencyKit.insert(item, at: 0)
                saveToCache(emergencyKit)
                queueOperation(type: .create, item: item)
                errorMessage = "Offline: item disimpan dan akan dikirim saat online."
            }
        } else {
            // Save locally and queue
            emergencyKit.insert(item, at: 0)
            saveToCache(emergencyKit)
            queueOperation(type: .create, item: item)
            errorMessage = "Offline: item disimpan dan akan dikirim saat online."
        }
        pendingCount = queue.pendingCount()
    }

    /// Delete an item from the kit. Works offline: queues the deletion and syncs later.
    func deleteItem(id: String) async {
        guard let item = emergencyKit.first(where: { $0.id == id }) else { return }

        // Optimistic removal
        emergencyKit.removeAll { $0.id == id }
        saveToCache(emergencyKit)

        if networkMonitor.isConnected {
            do {
                try await repository.deleteItem(id: id)
            } catch {
                // Re-insert on failure and queue
                emergencyKit.insert(item, at: 0)
                saveToCache(emergencyKit)
                queueOperation(type: .delete, item: item)
                errorMessage = "Offline: penghapusan akan dikirim saat online."
            }
        } else {
            queueOperation(type: .delete, item: item)
        }
        pendingCount = queue.pendingCount()
    }

    // MARK: - Offline Queue Flush

    func flushPendingOperations() async {
        guard networkMonitor.isConnected else { return }
        await queue.flush(using: repository)
        pendingCount = queue.pendingCount()
    }

    // MARK: - Cache Helpers

    private func saveToCache(_ items: [ChecklistItem]) {
        storage.save(items, forKey: cacheKey)
        storage.save(Date(), forKey: cacheTimestampKey)
        print("💾 [Cache] Saved \(items.count) item(s) to local cache.")
    }

    private func loadFromCache() {
        if let cached: [ChecklistItem] = storage.load(forKey: cacheKey), !cached.isEmpty {
            self.emergencyKit = cached
            print("📦 [Cache] Loaded \(cached.count) item(s) from local cache (offline mode).")
        } else if self.emergencyKit.isEmpty {
            self.emergencyKit = Self.mockKitItems
            print("⚠️ [Fallback] No cache available, using mock data.")
        }
    }

    var lastCachedDate: Date? {
        storage.load(forKey: cacheTimestampKey)
    }

    // MARK: - Queue Helper

    private func queueOperation(type: PendingOperationType, item: ChecklistItem) {
        let op = PendingChecklistOperation(
            id: UUID().uuidString,
            type: type,
            item: item,
            queuedAt: Date()
        )
        queue.enqueue(op)
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
        ChecklistItem(id: UUID().uuidString, name: "First Aid Kit",         isChecked: true,  category: .firstAid,      quantity: 1, priority: .high,   disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Water (3L/person/day)", isChecked: true,  category: .water,         quantity: 3, priority: .high,   disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Flashlight & Batteries",isChecked: false, category: .lighting,      quantity: 1, priority: .medium, disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Emergency Food (3 days)",isChecked: false,category: .food,          quantity: 3, priority: .high,   disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Whistle",               isChecked: false, category: .communication, quantity: 1, priority: .medium, disasterType: "All"),
        ChecklistItem(id: UUID().uuidString, name: "Copies of Documents",   isChecked: false, category: .documents,     quantity: 1, priority: .medium, disasterType: "All"),
    ]

    private static let mockRiskProfiles: [RiskProfile] = [
        RiskProfile(id: "1", type: "Earthquake", iconName: "waveform.path.ecg",    level: .high),
        RiskProfile(id: "2", type: "Flood",      iconName: "cloud.heavyrain.fill",  level: .medium),
        RiskProfile(id: "3", type: "Tsunami",    iconName: "water.waves",           level: .low),
    ]
}
