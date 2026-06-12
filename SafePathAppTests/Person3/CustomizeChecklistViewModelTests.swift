import Foundation
import Testing

@testable import SafePath

@Suite("CustomizeChecklist ViewModel Tests")
@MainActor
struct CustomizeChecklistViewModelTests {

    @Test("Fungsi: loadCustomItems() - Skenario Berhasil")
    func testLoadCustomItemsSuccess() async throws {
        let mockRepo = MockChecklistRepository()
        mockRepo.customItemsToReturn = [
            TestDataFactory.mockChecklistItem(name: "Radio")
        ]

        let vm = CustomizeChecklistViewModel(repository: mockRepo)
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.customItems.count == 1)
        #expect(vm.customItems.first?.name == "Radio")
    }

    @Test("Fungsi: loadCustomItems() - Skenario Gagal")
    func testLoadCustomItemsFailure() async throws {
        let mockRepo = MockChecklistRepository()
        mockRepo.shouldThrowError = true

        let vm = CustomizeChecklistViewModel(repository: mockRepo)
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.customItems.isEmpty)
    }

    @Test("Fungsi: saveItem() - Berhasil Menyimpan")
    func testSaveItemSuccess() async throws {
        let mockRepo = MockChecklistRepository()
        let vm = CustomizeChecklistViewModel(repository: mockRepo)

        vm.itemName = "Powerbank"
        vm.quantity = 2
        vm.priority = .high
        vm.disasterType = "All"
        vm.selectedCategory = .communication

        vm.saveItem()
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(mockRepo.savedItems.count == 1)
        let saved = mockRepo.savedItems.first
        #expect(saved?.name == "Powerbank")
        #expect(saved?.quantity == 2)
        
        // Pastikan form direset setelah save
        #expect(vm.itemName.isEmpty)
        #expect(vm.quantity == 1)
    }

    @Test("Fungsi: saveItem() - Gagal Karena Nama Kosong")
    func testSaveItemEmptyName() async throws {
        let mockRepo = MockChecklistRepository()
        let vm = CustomizeChecklistViewModel(repository: mockRepo)

        vm.itemName = ""
        vm.saveItem()
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(mockRepo.savedItems.isEmpty)
    }

    @Test("Fungsi: deleteItem() - Skenario Berhasil")
    func testDeleteItem() async throws {
        let mockRepo = MockChecklistRepository()
        let idToDelete = "123-abc"
        
        let vm = CustomizeChecklistViewModel(repository: mockRepo)
        vm.deleteItem(id: idToDelete)
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(mockRepo.deletedItemIds.contains(idToDelete))
    }
}

//
