import Foundation
import Testing
@testable import SafePath


@Suite("Shelter Repository Tests")
struct ShelterRepositoryTests {
    
    @Test("Fungsi: fetchAllShelters() - Skenario Berhasil")
    func testFetchSheltersSuccess() async throws {
        let repo = MockShelterRepository()
        repo.sheltersToReturn = [TestDataFactory.mockShelter()]
        
        let shelters = try await repo.fetchAllShelters()
        #expect(shelters.count == 1)
    }
    
    @Test("Fungsi: fetchAllShelters() - Skenario Gagal")
    func testFetchSheltersFailure() async {
        let repo = MockShelterRepository()
        repo.shouldThrowError = true
        
        do {
            _ = try await repo.fetchAllShelters()
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(error != nil)
        }
    }
    
    @Test("Fungsi: fetchShelterDetail() - Skenario Berhasil")
    func testFetchShelterDetailSuccess() async throws {
        let repo = MockShelterRepository()
        repo.singleShelterToReturn = TestDataFactory.mockShelter(id: 10)
        
        let shelter = try await repo.fetchShelter(id: 10)
        #expect(shelter.id == 10)
    }
    
    @Test("Fungsi: fetchNearbyShelters() - Skenario Berhasil")
    func testFetchNearbySheltersSuccess() async throws {
        let repo = MockShelterRepository()
        repo.sheltersToReturn = [TestDataFactory.mockShelter()]
        
        let shelters = try await repo.fetchNearbyShelters(lat: 0.0, lng: 0.0)
        #expect(!shelters.isEmpty)
    }
    
    @Test("Fungsi: fetchRecommendedShelters() - Skenario Berhasil")
    func testFetchRecommendedSheltersSuccess() async throws {
        let repo = MockShelterRepository()
        repo.sheltersToReturn = [TestDataFactory.mockShelter(buildingLevel: 4)]
        
        let shelters = try await repo.fetchRecommendedShelters(lat: 0.0, lng: 0.0, disasterType: "flood")
        #expect(shelters.first?.buildingLevel == 4)
    }
}
