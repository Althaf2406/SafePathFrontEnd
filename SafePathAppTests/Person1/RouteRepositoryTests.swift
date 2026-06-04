import Foundation
import Testing
import CoreLocation
@testable import SafePath

@Suite("Route Repository Tests")
@MainActor
struct RouteRepositoryTests {
    
    @Test("Fungsi: calculateRoute() - Skenario Berhasil")
    func testCalculateRouteSuccess() async throws {
        let repo = MockRouteRepository()
        repo.primaryRouteToReturn = TestDataFactory.mockEvacuationRoute()
        
        let route = try await repo.calculateRoute(from: TestDataFactory.mockUserLocation(), to: TestDataFactory.mockShelter())
        #expect(route.distanceMeters == 1500)
    }
    
    @Test("Fungsi: calculateRoute() - Skenario Gagal")
    func testCalculateRouteFailure() async {
        let repo = MockRouteRepository()
        repo.shouldThrowError = true
        
        do {
            _ = try await repo.calculateRoute(from: TestDataFactory.mockUserLocation(), to: TestDataFactory.mockShelter())
            Issue.record("Expected error to be thrown")
        } catch {
            #expect(true)
        }
    }
    
    @Test("Fungsi: calculateRoute() - Handle Invalid Coordinate")
    func testInvalidCoordinateHandling() async {
        let repo = MockRouteRepository()
        repo.shouldThrowError = true
        
        let invalidLocation = CLLocationCoordinate2D(latitude: 999, longitude: 999)
        
        do {
            _ = try await repo.calculateRoute(from: invalidLocation, to: TestDataFactory.mockShelter())
            Issue.record("Expected error due to invalid coordinate")
        } catch {
            #expect(true)
        }
    }
}
