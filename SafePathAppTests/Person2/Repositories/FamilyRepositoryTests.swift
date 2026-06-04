import Foundation
import Testing
@testable import SafePath


@Suite("FamilyRepository Tests")
struct FamilyRepositoryTests {

    @Test("Fungsi: fetchAllGroups() - Skenario Berhasil")
    func testFetchAllGroupsSuccess() async throws {
        let mockAPI = MockAPIService()
        let mockGroup = TestDataFactory.mockFamilyGroup(name: "API Group")
        mockAPI.responseToReturn = [mockGroup]
        
        let repo = FamilyRepository(api: mockAPI)
        let groups = try await repo.fetchAllGroups(authToken: "token")
        
        #expect(groups.count == 1)
        #expect(groups.first?.name == "API Group")
    }

    @Test("Fungsi: createGroup() - Skenario Gagal")
    func testCreateGroupFailure() async {
        let mockAPI = MockAPIService()
        mockAPI.shouldThrowError = true
        
        let repo = FamilyRepository(api: mockAPI)
        
        do {
            _ = try await repo.createGroup(authToken: "token", name: "Test")
            Issue.record("Diharapkan error, tapi sukses")
        } catch {
            #expect(error != nil)
        }
    }
}
