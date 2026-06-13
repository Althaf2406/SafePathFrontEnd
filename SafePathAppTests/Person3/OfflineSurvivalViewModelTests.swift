import Foundation
import Testing

@testable import SafePath

@Suite("OfflineSurvivalViewModel Tests")
@MainActor
struct OfflineSurvivalViewModelTests {

    @Test("Fungsi: Computed Properties")
    func testComputedProperties() {
        let vm = OfflineSurvivalViewModel()
        
        // Setup dummy data
        vm.cachedEmergencyKit = [
            TestDataFactory.mockChecklistItem(name: "Radio", isChecked: true),
            TestDataFactory.mockChecklistItem(name: "Water", isChecked: false)
        ]
        
        #expect(vm.totalCount == 2)
        #expect(vm.completedCount == 1)
        #expect(vm.readiness == 0.5)
    }
    
    @Test("Fungsi: Readiness - Empty Kit")
    func testReadinessEmpty() {
        let vm = OfflineSurvivalViewModel()
        vm.cachedEmergencyKit = []
        #expect(vm.readiness == 0)
    }
}
