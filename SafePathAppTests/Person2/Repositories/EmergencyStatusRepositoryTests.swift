import Foundation
import Testing
@testable import SafePath


@Suite("EmergencyStatusRepository Tests")
@MainActor
struct EmergencyStatusRepositoryTests {

    @Test("Fungsi: triggerSOS() - Skenario Berhasil")
    func testTriggerSOSSuccess() async throws {
        let mockAPI = MockAPIService()
        let mockStatus = TestDataFactory.mockEmergencyStatus(isSOS: true)
        mockAPI.responseToReturn = mockStatus
        
        let repo = EmergencyStatusRepository(api: mockAPI)
        let status = try await repo.triggerSOS(latitude: nil, longitude: nil, message: "Help!")
        
        #expect(status.isSOS == true)
    }

    @Test("Fungsi: updateStatus() - Skenario Gagal")
    func testUpdateStatusFailure() async {
        let mockAPI = MockAPIService()
        mockAPI.shouldThrowError = true
        
        let repo = EmergencyStatusRepository(api: mockAPI)
        
        do {
            _ = try await repo.updateStatus(status: .safe, message: nil, latitude: nil, longitude: nil)
            Issue.record("Diharapkan error, tapi sukses")
        } catch {
            #expect(error != nil)
        }
    }
}
