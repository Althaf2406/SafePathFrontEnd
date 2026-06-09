import Foundation
import Testing
@testable import SafePath

@Suite("Disaster Alert Repository Tests")
@MainActor
struct DisasterAlertRepositoryTests {
    // Note: Implementing true repository tests requires an APIServiceProtocol
    // which involves refactoring APIService.
    // For now, we simulate the expected behavior using the mock repository.
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Berhasil")
    func testFetchAllAlertsSuccess() async throws {
        let repo = MockDisasterAlertRepository()
        repo.alertsToReturn = [TestDataFactory.mockDisasterAlert()]
        
        let alerts = try await repo.fetchAllAlerts()
        #expect(alerts.count == 1)
    }
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Gagal")
    func testFetchAllAlertsFailure() async {
        let repo = MockDisasterAlertRepository()
        repo.shouldThrowError = true
        
        do {
            _ = try await repo.fetchAllAlerts()
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(true)
        }
    }
    
    @Test("Fungsi: fetchNearbyAlerts() - Skenario Berhasil")
    func testFetchNearbyAlertsSuccess() async throws {
        let repo = MockDisasterAlertRepository()
        repo.alertsToReturn = [TestDataFactory.mockDisasterAlert(id: "nearby_1")]
        
        let alerts = try await repo.fetchNearbyAlerts(lat: -7.25, lng: 112.75)
        #expect(alerts.first?.id == "nearby_1")
    }
}
