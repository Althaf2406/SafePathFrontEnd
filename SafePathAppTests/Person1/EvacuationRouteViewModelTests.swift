import Foundation
import Testing
import CoreLocation


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
}
