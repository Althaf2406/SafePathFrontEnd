import Foundation
import Testing
import CoreLocation

@testable import SafePath

@Suite("Shelter ViewModel Tests")
@MainActor
struct ShelterViewModelTests {
    
    @Test("Fungsi: fetchAllShelters() - Skenario Berhasil")
    func testFetchSheltersSuccess() async {
        let mockRepo = MockShelterRepository()
        mockRepo.sheltersToReturn = [
            TestDataFactory.mockShelter(name: "GOR Bung Tomo")
        ]
        
        let vm = ShelterViewModel(repository: mockRepo)
        await vm.fetchAllShelters()
        
        #expect(vm.shelters.count == 1)
        if case .loaded(let shelters) = vm.state {
            #expect(shelters.count == 1)
        } else {
            Issue.record("State was not .loaded")
        }
    }
    
    @Test("Fungsi: fetchAllShelters() - Skenario Data Kosong")
    func testFetchSheltersEmpty() async {
        let mockRepo = MockShelterRepository()
        mockRepo.sheltersToReturn = []
        
        let vm = ShelterViewModel(repository: mockRepo)
        await vm.fetchAllShelters()
        
        #expect(vm.shelters.isEmpty)
        if case .empty = vm.state {
            #expect(true)
        } else {
            Issue.record("State was not .empty")
        }
    }
    
    @Test("Fungsi: fetchAllShelters() - Skenario Gagal (Fallback ke Mock Data)")
    func testFetchSheltersFailure() async {
        let mockRepo = MockShelterRepository()
        mockRepo.shouldThrowError = true
        
        let vm = ShelterViewModel(repository: mockRepo)
        await vm.fetchAllShelters()
        
        // Karena ada mekanisme fallback ke data mock, list tidak boleh kosong.
        #expect(!vm.shelters.isEmpty)
        if case .loaded(let shelters) = vm.state {
            #expect(!shelters.isEmpty)
        } else {
            Issue.record("State was not .loaded dengan fallback data")
        }
    }
    
    @Test("Fungsi: fetchShelterDetail(id:) - Skenario Berhasil")
    func testFetchShelterDetailSuccess() async {
        let mockRepo = MockShelterRepository()
        mockRepo.singleShelterToReturn = TestDataFactory.mockShelter(id: 99, name: "Balai RW")
        
        let vm = ShelterViewModel(repository: mockRepo)
        await vm.fetchShelterDetail(id: 99)
        
        #expect(vm.shelterDetail?.id == 99)
        #expect(vm.shelterDetail?.name == "Balai RW")
    }
    
    @Test("Fungsi: fetchNearbyShelters() - Skenario Berhasil")
    func testFetchNearbySheltersSuccess() async {
        let mockRepo = MockShelterRepository()
        mockRepo.sheltersToReturn = [
            TestDataFactory.mockShelter(id: 1, distanceKm: 2.0),
            TestDataFactory.mockShelter(id: 2, distanceKm: 0.5)
        ]
        
        let vm = ShelterViewModel(repository: mockRepo)
        await vm.fetchNearbyShelters(location: TestDataFactory.mockUserLocation())
        
        #expect(vm.nearbyShelters.count == 2)
        
        // test active filter nearest sorting
        vm.activeFilter = .nearest
        let filtered = vm.filteredShelters
        #expect(filtered.first?.id == 2) // closest first
    }
    
    @Test("Fungsi: fetchRecommendedShelters(disasterType:) - Skenario Banjir")
    func testFetchRecommendedSheltersFlood() async {
        let mockRepo = MockShelterRepository()
        // For flood, typically buildingLevel >= 3
        mockRepo.sheltersToReturn = [
            TestDataFactory.mockShelter(buildingLevel: 3)
        ]
        
        let vm = ShelterViewModel(repository: mockRepo)
        await vm.fetchRecommendedShelters(location: TestDataFactory.mockUserLocation(), disasterType: "flood")
        
        #expect(vm.recommendedShelters.count == 1)
        #expect(vm.recommendedShelters.first?.buildingLevel == 3)
    }
    
    @Test("Fungsi: selectShelter() - Skenario Berhasil")
    func testSelectShelter() async {
        let vm = ShelterViewModel(repository: MockShelterRepository())
        let shelter = TestDataFactory.mockShelter(id: 5)
        
        vm.selectShelter(shelter)
        
        #expect(vm.selectedShelter?.id == 5)
    }
}
