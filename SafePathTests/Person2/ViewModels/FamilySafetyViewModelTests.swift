import Foundation
import Testing

@testable import SafePath

@Suite("FamilySafety ViewModel Tests")
@MainActor
struct FamilySafetyViewModelTests {

    @Test("Fungsi: createGroup() - Skenario Berhasil")
    func testCreateGroupSuccess() async {
        let mockRepo = MockFamilyRepository()
        let vm = FamilySafetyViewModel(repository: mockRepo)
        
        await vm.createGroup(authToken: "token", name: "My Family")
        
        #expect(vm.familyGroup != nil)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: createGroup() - Skenario Gagal")
    func testCreateGroupFailure() async {
        let mockRepo = MockFamilyRepository()
        mockRepo.shouldThrowError = true
        let vm = FamilySafetyViewModel(repository: mockRepo)
        
        await vm.createGroup(authToken: "token", name: "My Family")
        
        #expect(vm.familyGroup == nil)
        #expect(vm.errorMessage != nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: inviteMember() - Skenario Berhasil")
    func testInviteMemberSuccess() async {
        let mockRepo = MockFamilyRepository()
        let vm = FamilySafetyViewModel(repository: mockRepo)
        vm.familyGroup = TestDataFactory.mockFamilyGroup()
        
        await vm.inviteMember(authToken: "token", phone: "123456789")
        
        #expect(vm.members.isEmpty == false)
        #expect(vm.errorMessage == nil)
    }

    @Test("Fungsi: removeMember() - Skenario Berhasil")
    func testRemoveMemberSuccess() async {
        let mockRepo = MockFamilyRepository()
        let vm = FamilySafetyViewModel(repository: mockRepo)
        let member = TestDataFactory.mockFamilyMember(id: "m1")
        vm.familyGroup = TestDataFactory.mockFamilyGroup(members: [member])
        vm.members = [member]
        
        await vm.removeMember(authToken: "token", memberID: "m1")
        
        #expect(vm.members.isEmpty == true)
        #expect(mockRepo.didCallRemoveMember == true)
        #expect(vm.errorMessage == nil)
    }

    @Test("Fungsi: shareLocation() - Skenario Berhasil")
    func testShareLocationSuccess() async {
        let mockRepo = MockFamilyRepository()
        let vm = FamilySafetyViewModel(repository: mockRepo)
        vm.familyGroup = TestDataFactory.mockFamilyGroup()
        
        await vm.shareLocation(authToken: "token", latitude: -7.0, longitude: 112.0)
        
        #expect(mockRepo.didCallShareLocation == true)
        #expect(vm.errorMessage == nil)
    }

    @Test("Fungsi: fetchFamilyLocations() - Skenario Berhasil")
    func testFetchFamilyLocationsSuccess() async {
        let mockRepo = MockFamilyRepository()
        let vm = FamilySafetyViewModel(repository: mockRepo)
        vm.familyGroup = TestDataFactory.mockFamilyGroup()
        
        await vm.fetchFamilyLocations(authToken: "token")
        
        #expect(vm.members.isEmpty == false)
        #expect(vm.isLoading == false)
        #expect(vm.errorMessage == nil)
    }
}
