import Foundation
import Testing
import CoreLocation
@testable import SafePath


@Suite("DisasterAlert ViewModel Tests")
@MainActor
struct DisasterAlertViewModelTests {
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Berhasil")
    func testFetchAlertsSuccess() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.alertsToReturn = [
            TestDataFactory.mockDisasterAlert(id: "1", type: "earthquake")
        ]
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchAllAlerts()
        
        #expect(vm.allAlerts.count == 1)
        if case .loaded(let alerts) = vm.state {
            #expect(alerts.count == 1)
        } else {
            Issue.record("State was not .loaded")
        }
    }
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Data Kosong")
    func testFetchAlertsEmpty() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.alertsToReturn = []
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchAllAlerts()
        
        #expect(vm.allAlerts.isEmpty)
        if case .empty = vm.state {
            #expect(true)
        } else {
            Issue.record("State was not .empty")
        }
    }
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Gagal (Fallback ke Mock Data)")
    func testFetchAlertsFailure() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.shouldThrowError = true
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchAllAlerts()
        
        // Karena ada mekanisme fallback ke data mock, list tidak boleh kosong.
        #expect(!vm.allAlerts.isEmpty)
        if case .loaded(let alerts) = vm.state {
            #expect(!alerts.isEmpty)
        } else {
            Issue.record("State was not .loaded dengan fallback data")
        }
    }
    
    @Test("Fungsi: fetchNearbyAlerts() - Skenario Berhasil dengan Lokasi")
    func testFetchNearbyAlertsSuccess() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.alertsToReturn = [
            TestDataFactory.mockDisasterAlert(
                id: "near1",
                type: "flood",
                locationName: "Surabaya"
            )
        ]
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchNearbyAlerts(location: TestDataFactory.mockUserLocation())
        
        #expect(vm.nearbyAlerts.count == 1)
        #expect(vm.nearbyAlerts.first?.type == "flood")
    }
    
    @Test("Fungsi: filterSeverity - Uji Severity Tingkat Tinggi")
    func testSeverityMapping() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.alertsToReturn = [
            TestDataFactory.mockDisasterAlert(severity: .critical),
            TestDataFactory.mockDisasterAlert(severity: .low)
        ]
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchAllAlerts()
        
        #expect(vm.allAlerts.count == 2)
        #expect(vm.criticalAlerts.count == 1)
        #expect(vm.highSeverityAlerts.count == 1)
        #expect(vm.criticalAlerts.first?.severity == .critical)
    }
}
