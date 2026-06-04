import Foundation
import Testing

@testable import SafePath

@Suite("EmergencyStatus ViewModel Tests")
@MainActor
struct EmergencyStatusViewModelTests {

    @Test("Fungsi: updateStatus() - Skenario Berhasil")
    func testUpdateStatusSuccess() async {
        let mockRepo = MockEmergencyStatusRepository()
        let vm = EmergencyStatusViewModel(repository: mockRepo)
        
        await vm.updateStatus(authToken: "token", status: .safe, latitude: -7.0, longitude: 112.0)
        
        #expect(vm.currentStatus != nil)
        #expect(vm.currentStatus?.status == .safe)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: updateStatus() - Skenario Gagal")
    func testUpdateStatusFailure() async {
        let mockRepo = MockEmergencyStatusRepository()
        mockRepo.shouldThrowError = true
        let vm = EmergencyStatusViewModel(repository: mockRepo)
        
        await vm.updateStatus(authToken: "token", status: .safe)
        
        #expect(vm.currentStatus == nil)
        #expect(vm.errorMessage != nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: triggerSOS() - Skenario Berhasil")
    func testTriggerSOSSuccess() async {
        let mockRepo = MockEmergencyStatusRepository()
        let vm = EmergencyStatusViewModel(repository: mockRepo)
        
        await vm.triggerSOS(authToken: "token", latitude: -7.0, longitude: 112.0)
        
        #expect(vm.currentStatus?.isSOS == true)
        #expect(vm.isSOSActive == true)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: resolveSOS() - Skenario Berhasil")
    func testResolveSOSSuccess() async {
        let mockRepo = MockEmergencyStatusRepository()
        let vm = EmergencyStatusViewModel(repository: mockRepo)
        vm.currentStatus = TestDataFactory.mockEmergencyStatus(isSOS: true)
        vm.isSOSActive = true
        
        await vm.resolveSOS(authToken: "token")
        
        #expect(vm.currentStatus?.isSOS == false)
        #expect(vm.isSOSActive == false)
        #expect(vm.errorMessage == nil)
    }

    @Test("Fungsi: fetchFamilyStatuses() - Skenario Berhasil")
    func testFetchFamilyStatusesSuccess() async {
        let mockRepo = MockEmergencyStatusRepository()
        let vm = EmergencyStatusViewModel(repository: mockRepo)
        
        await vm.fetchFamilyStatuses(authToken: "token", groupID: "group1")
        
        #expect(vm.familyStatuses.isEmpty == false)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }
}
