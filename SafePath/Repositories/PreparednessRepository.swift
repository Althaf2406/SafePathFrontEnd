import Foundation
import Combine

/// Person 3: Repository for preparedness data persistence.
final class PreparednessRepository {
    // TODO: Person 3 will implement local storage for reminders using Core Data or UserDefaults.
    
    private let api: APIService
    
    init(api: APIService = .shared) {
        self.api = api
    }
    
    /// Fetch all item.
    func getAllItem() async throws -> [ChecklistItem] {
        return try await api.fetchData(.getAllItem)
    }
    
    /// Fetch disaster alerts near a coordinate.
//    func fetchNearbyAlerts(lat: Double, lng: Double) async throws -> [DisasterAlert] {
//        return try await fetchNearbyAlerts(lat: lat, lng: lng, radiusKm: AppConstants.alertProximityThresholdKm)
//    }
//
//    func fetchNearbyAlerts(lat: Double, lng: Double, radiusKm: Double) async throws -> [DisasterAlert] {
//        return try await api.fetchData(.nearbyAlerts(lat: lat, lng: lng, radiusKm: radiusKm))
//    }
}
