import Foundation
import CoreLocation
import Combine
@testable import SafePath

final class MockDisasterAlertRepository: DisasterAlertRepositoryProtocol {
    var shouldThrowError = false
    var alertsToReturn: [DisasterAlert] = []
    
    func fetchAllAlerts() async throws -> [DisasterAlert] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return alertsToReturn
    }
    
    func fetchNearbyAlerts(lat: Double, lng: Double) async throws -> [DisasterAlert] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return alertsToReturn
    }
    
    func fetchNearbyAlerts(lat: Double, lng: Double, radiusKm: Double) async throws -> [DisasterAlert] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return alertsToReturn
    }
}

final class MockShelterRepository: ShelterRepositoryProtocol {
    var shouldThrowError = false
    var sheltersToReturn: [Shelter] = []
    var singleShelterToReturn: Shelter?
    
    func fetchAllShelters() async throws -> [Shelter] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return sheltersToReturn
    }
    
    func fetchShelter(id: Int) async throws -> Shelter {
        if shouldThrowError { throw URLError(.badServerResponse) }
        guard let shelter = singleShelterToReturn else { throw URLError(.resourceUnavailable) }
        return shelter
    }
    
    func fetchNearbyShelters(lat: Double, lng: Double) async throws -> [Shelter] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return sheltersToReturn
    }
    
    func fetchNearbyShelters(lat: Double, lng: Double, radiusKm: Double) async throws -> [Shelter] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return sheltersToReturn
    }
    
    func fetchRecommendedShelters(lat: Double, lng: Double, disasterType: String) async throws -> [Shelter] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return sheltersToReturn
    }
}

final class MockRouteRepository: RouteRepositoryProtocol {
    var shouldThrowError = false
    var primaryRouteToReturn: EvacuationRoute?
    var alternativesToReturn: [EvacuationRoute] = []
    
    func calculateRoute(from origin: CLLocationCoordinate2D, to shelter: Shelter) async throws -> EvacuationRoute {
        if shouldThrowError { throw URLError(.badServerResponse) }
        guard let route = primaryRouteToReturn else { throw URLError(.resourceUnavailable) }
        return route
    }
    
    func calculateRouteWithAlternatives(from origin: CLLocationCoordinate2D, to shelter: Shelter) async throws -> (primary: EvacuationRoute, alternatives: [EvacuationRoute]) {
        if shouldThrowError { throw URLError(.badServerResponse) }
        guard let route = primaryRouteToReturn else { throw URLError(.resourceUnavailable) }
        return (route, alternativesToReturn)
    }
}

final class MockLocationService: LocationServiceProtocol {
    var currentLocation: CLLocationCoordinate2D?
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    var locationError: String?
    var isAuthorized: Bool = false
    
    var requestPermissionCalled = false
    var startUpdatingCalled = false
    var stopUpdatingCalled = false
    
    func requestPermission() {
        requestPermissionCalled = true
        authorizationStatus = .authorizedWhenInUse
        isAuthorized = true
    }
    
    func startUpdating() {
        startUpdatingCalled = true
    }
    
    func stopUpdating() {
        stopUpdatingCalled = true
    }
}
