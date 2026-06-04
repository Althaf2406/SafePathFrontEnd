import Foundation
import Testing

@testable import SafePath

@Suite("DisasterPreparation ViewModel Tests")
@MainActor
struct DisasterPreparationViewModelTests {

    @Test("Fungsi: loadGuides() - Skenario Berhasil")
    func testLoadGuidesSuccess() async throws {
        let mockPrepRepo = MockDisasterPreparationRepository()
        let mockChecklistRepo = MockChecklistRepository()
        
        mockPrepRepo.guidesToReturn = [
            TestDataFactory.mockDisasterPreparationGuide(disasterType: "Flood", title: "Flood Guide"),
            TestDataFactory.mockDisasterPreparationGuide(disasterType: "Fire", title: "Fire Guide")
        ]

        let vm = DisasterPreparationViewModel(prepRepository: mockPrepRepo, checklistRepository: mockChecklistRepo)
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.guides.count == 2)
        #expect(vm.guides[0].disasterType == "Flood")
    }

    @Test("Fungsi: loadChecklist(for:) - Hanya Menampilkan Tipe Bencana Terkait")
    func testLoadChecklistFilter() async throws {
        let mockPrepRepo = MockDisasterPreparationRepository()
        let mockChecklistRepo = MockChecklistRepository()
        
        mockChecklistRepo.customItemsToReturn = [
            TestDataFactory.mockChecklistItem(name: "Life Jacket", disasterType: "Flood"),
            TestDataFactory.mockChecklistItem(name: "N95 Mask", disasterType: "Fire"),
            TestDataFactory.mockChecklistItem(name: "Water", disasterType: "All")
        ]

        let vm = DisasterPreparationViewModel(prepRepository: mockPrepRepo, checklistRepository: mockChecklistRepo)
        
        vm.loadChecklist(for: "Flood")
        try await Task.sleep(nanoseconds: 10_000_000)

        // Harus berisi "Flood" dan "All"
        #expect(vm.checklistItems.count == 2)
        #expect(vm.checklistItems.contains(where: { $0.name == "Life Jacket" }))
        #expect(vm.checklistItems.contains(where: { $0.name == "Water" }))
        #expect(!vm.checklistItems.contains(where: { $0.name == "N95 Mask" }))
    }
}
