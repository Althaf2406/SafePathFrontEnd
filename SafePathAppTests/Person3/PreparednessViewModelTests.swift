import Foundation
import Testing

@testable import SafePath

@Suite("Preparedness ViewModel Tests")
@MainActor
struct PreparednessViewModelTests {

    @Test("Fungsi: load() - Berhasil Memuat Item dan Profil Risiko")
    func testLoadSuccess() async throws {
        let mockRepo = MockPreparednessRepository()
        mockRepo.itemsToReturn = [
            TestDataFactory.mockChecklistItem(name: "Water", isChecked: true),
            TestDataFactory.mockChecklistItem(name: "Food", isChecked: false)
        ]
        mockRepo.riskProfilesToReturn = [
            TestDataFactory.mockRiskProfile(type: "Flood", level: .high)
        ]

        let vm = PreparednessViewModel(repository: mockRepo)
        
        await vm.load(lat: 0, lng: 0)

        #expect(vm.emergencyKit.count == 2)
        #expect(vm.riskProfiles.count == 1)
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }

    @Test("Fungsi: Computed Properties - Kalkulasi Akurat")
    func testComputedProperties() async throws {
        let mockRepo = MockPreparednessRepository()
        mockRepo.itemsToReturn = [
            TestDataFactory.mockChecklistItem(name: "Item 1", isChecked: true),
            TestDataFactory.mockChecklistItem(name: "Item 2", isChecked: true),
            TestDataFactory.mockChecklistItem(name: "Item 3", isChecked: false),
            TestDataFactory.mockChecklistItem(name: "Item 4", isChecked: false)
        ]

        let vm = PreparednessViewModel(repository: mockRepo)
        await vm.getAllItem()

        #expect(vm.totalItemsCount == 4)
        #expect(vm.completedItemsCount == 2)
        #expect(vm.overallReadiness == 0.5) // 2 dari 4 (50%)
    }

    @Test("Fungsi: toggleItem() - Skenario Berhasil")
    func testToggleItemSuccess() async throws {
        let mockRepo = MockPreparednessRepository()
        let item = TestDataFactory.mockChecklistItem(name: "Item 1", isChecked: false)
        mockRepo.itemsToReturn = [item]

        let vm = PreparednessViewModel(repository: mockRepo)
        await vm.getAllItem()
        
        await vm.toggleItem(item)

        #expect(mockRepo.savedItems.count == 1)
        #expect(mockRepo.savedItems.first?.isChecked == true)
        #expect(vm.emergencyKit.first?.isChecked == true)
    }

    @Test("Fungsi: addItem() - Skenario Berhasil")
    func testAddItemSuccess() async throws {
        let mockRepo = MockPreparednessRepository()
        let vm = PreparednessViewModel(repository: mockRepo)

        let newItem = TestDataFactory.mockChecklistItem(name: "New Flashlight")
        await vm.addItem(newItem)

        #expect(mockRepo.savedItems.count == 1)
        #expect(vm.emergencyKit.count == 1)
        #expect(vm.emergencyKit.first?.name == "New Flashlight")
    }

    @Test("Fungsi: deleteItem() - Skenario Berhasil")
    func testDeleteItemSuccess() async throws {
        let mockRepo = MockPreparednessRepository()
        let item = TestDataFactory.mockChecklistItem(name: "Delete Me")
        mockRepo.itemsToReturn = [item]

        let vm = PreparednessViewModel(repository: mockRepo)
        await vm.getAllItem()

        await vm.deleteItem(id: item.id)

        #expect(mockRepo.deletedItemIds.contains(item.id))
        #expect(vm.emergencyKit.isEmpty)
    }

    @Test("Fungsi: load() - Skenario API Gagal Memakai Data Mock Fallback")
    func testLoadFailureUsesMockFallback() async throws {
        let mockRepo = MockPreparednessRepository()
        mockRepo.shouldThrowError = true // Simulasi gagal load backend

        let vm = PreparednessViewModel(repository: mockRepo)
        
        await vm.load(lat: 0, lng: 0)

        // Karena repository gagal (throw), ViewModel harus mengisi dengan mock statis internalnya
        #expect(!vm.emergencyKit.isEmpty)
        #expect(!vm.riskProfiles.isEmpty)
    }
}

//
