import Foundation
import Testing
import CoreLocation
@testable import SafePath


@Suite("EvacuationRoute ViewModel Tests")
@MainActor
struct EvacuationRouteViewModelTests {
    
    @Test("Fungsi: calculateRoute() - Skenario Berhasil")
    func testGenerateRouteSuccess() async {
        let mockRepo = MockRouteRepository()
        let primaryRoute = TestDataFactory.mockEvacuationRoute()
        mockRepo.primaryRouteToReturn = primaryRoute
        mockRepo.alternativesToReturn = []
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        let shelter = TestDataFactory.mockShelter()
        let origin = TestDataFactory.mockUserLocation()
        
        await vm.calculateRoute(from: origin, to: shelter)
        
        #expect(vm.currentRoute != nil)
        #expect(vm.currentRoute?.distanceMeters == 1500)
        #expect(vm.isCalculating == false)
        #expect(vm.routeError == nil)
        #expect(vm.hasRoute == true)
    }
    
    @Test("Fungsi: calculateRoute() - Skenario Gagal")
    func testGenerateRouteFailure() async {
        let mockRepo = MockRouteRepository()
        mockRepo.shouldThrowError = true
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        let shelter = TestDataFactory.mockShelter()
        let origin = TestDataFactory.mockUserLocation()
        
        await vm.calculateRoute(from: origin, to: shelter)
        
        #expect(vm.currentRoute == nil)
        #expect(vm.routeError != nil)
        #expect(vm.isCalculating == false)
        #expect(vm.hasRoute == false)
    }
    
    @Test("Fungsi: recalculateRouteIfNeeded() - Jarak Cukup Jauh")
    func testRecalculateRouteIfNeed() async {
        let mockRepo = MockRouteRepository()
        let primaryRoute = TestDataFactory.mockEvacuationRoute()
        mockRepo.primaryRouteToReturn = primaryRoute
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        let shelter = TestDataFactory.mockShelter()
        let origin = TestDataFactory.mockUserLocation()
        
        // Since MKRoute is nil in mock, distance calculation will proceed or fail gracefully.
        // We'll just verify the call doesn't crash and works with our mock setup.
        await vm.calculateRoute(from: origin, to: shelter)
        #expect(vm.hasRoute == true)
        
        let newLocation = CLLocationCoordinate2D(latitude: -7.3, longitude: 112.8)
        await vm.recalculateIfNeeded(newLocation: newLocation, shelter: shelter)
        
        #expect(vm.hasRoute == true)
    }
    
    @Test("Fungsi: clearRoute() - Skenario Bersih")
    func testClearRoute() async {
        let mockRepo = MockRouteRepository()
        mockRepo.primaryRouteToReturn = TestDataFactory.mockEvacuationRoute()
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        await vm.calculateRoute(from: TestDataFactory.mockUserLocation(), to: TestDataFactory.mockShelter())
        
        vm.clearRoute()
        
        #expect(vm.currentRoute == nil)
        #expect(vm.hasRoute == false)
        #expect(vm.alternativeRoutes.isEmpty)
        #expect(vm.routeError == nil)
    }
    
    // MARK: - Alternative Route Selection Tests
    
    @Test("Fungsi: selectRoute() - Berhasil tukar rute")
    func testSelectAlternativeRouteSuccess() async {
        let mockRepo = MockRouteRepository()
        let primaryRoute = TestDataFactory.mockEvacuationRoute()
        var altRoute1 = TestDataFactory.mockEvacuationRoute()
        var altRoute2 = TestDataFactory.mockEvacuationRoute()
        
        // Ensure they have different distances to distinguish them
        mockRepo.primaryRouteToReturn = primaryRoute
        mockRepo.alternativesToReturn = [altRoute1, altRoute2]
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        await vm.calculateRoute(from: TestDataFactory.mockUserLocation(), to: TestDataFactory.mockShelter())
        
        #expect(vm.currentRoute?.id == primaryRoute.id)
        #expect(vm.alternativeRoutes.count == 2)
        
        vm.selectRoute(at: 1)
        
        #expect(vm.currentRoute?.id == altRoute2.id)
        #expect(vm.alternativeRoutes.count == 2)
        #expect(vm.alternativeRoutes[1].id == primaryRoute.id)
        #expect(vm.routeError == nil)
    }
    
    @Test("Fungsi: selectRoute() - Memperbarui ETA")
    func testSelectAlternativeRouteUpdatesETA() async {
        let mockRepo = MockRouteRepository()
        let primaryRoute = EvacuationRoute(id: "1", shelterId: "1", shelterName: "Shelter 1", distanceMeters: 1000, expectedTravelTime: 600, safetyScore: 0.8, mkRoute: nil, customPolyline: nil)
        let altRoute = EvacuationRoute(id: "2", shelterId: "1", shelterName: "Shelter 1", distanceMeters: 2000, expectedTravelTime: 1200, safetyScore: 0.7, mkRoute: nil, customPolyline: nil)
        
        mockRepo.primaryRouteToReturn = primaryRoute
        mockRepo.alternativesToReturn = [altRoute]
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        await vm.calculateRoute(from: TestDataFactory.mockUserLocation(), to: TestDataFactory.mockShelter())
        
        #expect(vm.routeETA == "10 min")
        
        vm.selectRoute(at: 0)
        
        #expect(vm.routeETA == "20 min")
    }
    
    @Test("Fungsi: selectRoute() - Index Tidak Valid")
    func testSelectInvalidAlternativeRouteIndex() async {
        let mockRepo = MockRouteRepository()
        let primaryRoute = TestDataFactory.mockEvacuationRoute()
        
        mockRepo.primaryRouteToReturn = primaryRoute
        mockRepo.alternativesToReturn = []
        
        let vm = EvacuationRouteViewModel(routeRepository: mockRepo)
        await vm.calculateRoute(from: TestDataFactory.mockUserLocation(), to: TestDataFactory.mockShelter())
        
        vm.selectRoute(at: 0)
        
        #expect(vm.currentRoute?.id == primaryRoute.id)
        #expect(vm.routeError == nil)
    }
}
