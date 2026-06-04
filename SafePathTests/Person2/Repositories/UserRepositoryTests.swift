import Foundation
import Testing

@testable import SafePath

@Suite("UserRepository Tests")
struct UserRepositoryTests {

    @Test("Fungsi: fetchProfile() - Skenario Berhasil")
    func testFetchProfileSuccess() async throws {
        let mockAPI = MockAPIService()
        let mockUser = TestDataFactory.mockUser(name: "API User")
        mockAPI.responseToReturn = mockUser
        
        let repo = UserRepository(api: mockAPI)
        let user = try await repo.fetchProfile(authToken: "token")
        
        #expect(user.name == "API User")
    }

    @Test("Fungsi: fetchProfile() - Skenario Gagal")
    func testFetchProfileFailure() async {
        let mockAPI = MockAPIService()
        mockAPI.shouldThrowError = true
        
        let repo = UserRepository(api: mockAPI)
        
        do {
            _ = try await repo.fetchProfile(authToken: "token")
            Issue.record("Diharapkan error, tapi sukses")
        } catch {
            #expect(error != nil)
        }
    }
}
