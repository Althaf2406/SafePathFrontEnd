import Foundation
import Testing

@testable import SafePath

@Suite("CustomizeChecklist ViewModel Tests")
@MainActor
struct CustomizeChecklistViewModelTests {

    @Test("Fungsi: Initialization - Form Fields")
    func testInitialState() {
        let vm = CustomizeChecklistViewModel()
        #expect(vm.itemName.isEmpty)
        #expect(vm.selectedCategory == .lighting)
        #expect(vm.quantity == 1)
        #expect(vm.priority == .high)
        #expect(vm.disasterType == "Flood")
        #expect(vm.isOffline == false)
        #expect(vm.customItems.isEmpty)
    }

    @Test("Fungsi: startEditing(_:) - Populate Form")
    func testStartEditing() {
        let vm = CustomizeChecklistViewModel()
        let item = ChecklistItem(id: "1", name: "Radio", isChecked: false, category: .communication, quantity: 2, priority: .high, disasterType: "All")
        
        vm.startEditing(item)
        
        #expect(vm.editingItemId == "1")
        #expect(vm.itemName == "Radio")
        #expect(vm.selectedCategory == .communication)
        #expect(vm.quantity == 2)
        #expect(vm.priority == .high)
        #expect(vm.disasterType == "All")
    }

    @Test("Fungsi: resetForm() - Reset Form Fields")
    func testResetForm() {
        let vm = CustomizeChecklistViewModel()
        vm.editingItemId = "123"
        vm.itemName = "Test"
        vm.quantity = 5
        
        vm.resetForm()
        
        #expect(vm.editingItemId == nil)
        #expect(vm.itemName == "")
        #expect(vm.quantity == 1)
    }
}
