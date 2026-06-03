import Combine
import Foundation

@MainActor
final class PreparednessViewModel: ObservableObject {

    @Published var emergencyKit: [ChecklistItem] = []
    @Published var isLoading = false

    private let repository: PreparednessRepository

    init(repository: PreparednessRepository = PreparednessRepository()) {
        self.repository = repository
    }

    func getAllItem() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let items = try await repository.getAllItem()
            self.emergencyKit = items
        } catch {
            print(error)
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
}
