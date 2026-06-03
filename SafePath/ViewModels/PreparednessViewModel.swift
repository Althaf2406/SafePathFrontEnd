import Foundation
import SwiftUI
import Combine

enum RiskLevel: String {
    case high = "High"
    case medium = "Medium"
    case low = "Low"
    
    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .green
        }
    }
}

struct RiskProfile: Identifiable {
    let id = UUID()
    let type: String
    let iconName: String
    let level: RiskLevel
}

@MainActor
final class PreparednessViewModel: ObservableObject {

    @Published var emergencyKit: [ChecklistItem] = []
    @Published var isLoading = false

    private let repository: PreparednessRepository

    @MainActor
    init(repository: PreparednessRepository) {
        self.repository = repository
    }
    
    @MainActor
    convenience init() {
        self.init(repository: PreparednessRepository())
    }
    
    // Missing properties for View
    @Published var riskProfiles: [RiskProfile] = [
        RiskProfile(type: "Earthquake", iconName: "waveform.path.ecg", level: .high),
        RiskProfile(type: "Flood", iconName: "cloud.rain", level: .medium)
    ]

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
