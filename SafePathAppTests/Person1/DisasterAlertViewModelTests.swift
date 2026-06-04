import Foundation
import Testing
import CoreLocation


@Suite("DisasterAlert ViewModel Tests")
@MainActor
struct DisasterAlertViewModelTests {
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Berhasil")
    func testFetchAlertsSuccess() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.alertsToReturn = [
            TestDataFactory.mockDisasterAlert(id: "1", title: "Gempa Bumi")
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
    
    @Test("Fungsi: fetchAllAlerts() - Skenario Gagal")
    func testFetchAlertsFailure() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.shouldThrowError = true
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchAllAlerts()
        
        #expect(vm.allAlerts.isEmpty)
        if case .error(let msg) = vm.state {
            #expect(!msg.isEmpty)
        } else {
            Issue.record("State was not .error")
        }
    }
    
    @Test("Fungsi: fetchNearbyAlerts() - Skenario Berhasil dengan Lokasi")
    func testFetchNearbyAlertsSuccess() async {
        let mockRepo = MockDisasterAlertRepository()
        mockRepo.alertsToReturn = [
            TestDataFactory.mockDisasterAlert(id: "near1", title: "Banjir")
        ]
        
        let vm = DisasterAlertViewModel(repository: mockRepo)
        await vm.fetchNearbyAlerts(location: TestDataFactory.mockUserLocation())
        
        #expect(vm.nearbyAlerts.count == 1)
        #expect(vm.nearbyAlerts.first?.title == "Banjir")
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
