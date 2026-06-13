import Foundation
import Testing

@testable import SafePath

@Suite("ChecklistViewModel Tests")
@MainActor
struct ChecklistViewModelTests {

    @Test("Fungsi: Initialization - Nilai Awal Kosong")
    func testInitialState() {
        let vm = ChecklistViewModel()
        #expect(vm.checklists.isEmpty)
        #expect(vm.activeChecklist == nil)
    }
}
