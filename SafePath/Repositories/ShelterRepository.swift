import Foundation
import Combine

protocol ShelterRepositoryProtocol {
    func fetchAllShelters() async throws -> [Shelter]
    func fetchShelter(id: Int) async throws -> Shelter
    func fetchNearbyShelters(lat: Double, lng: Double) async throws -> [Shelter]
    func fetchNearbyShelters(lat: Double, lng: Double, radiusKm: Double) async throws -> [Shelter]
    func fetchRecommendedShelters(lat: Double, lng: Double, disasterType: String) async throws -> [Shelter]
}

@MainActor
final class ShelterRepository: ShelterRepositoryProtocol {
    
    private let api: APIService
    
    @MainActor
    init(api: APIService? = nil) {
        self.api = api ?? APIService.shared
    }
    
    /// Fetch all shelters.
    func fetchAllShelters() async throws -> [Shelter] {
        return try await api.fetchData(.shelters)
    }
    
    /// Fetch a single shelter by ID.
    func fetchShelter(id: Int) async throws -> Shelter {
        return try await api.fetchData(.shelterDetail(id: id))
    }
    
    /// Fetch nearby shelters within radius.
    func fetchNearbyShelters(lat: Double, lng: Double) async throws -> [Shelter] {
        return try await fetchNearbyShelters(lat: lat, lng: lng, radiusKm: AppConstants.defaultRadiusKm)
    }
    
    func fetchNearbyShelters(lat: Double, lng: Double, radiusKm: Double) async throws -> [Shelter] {
        return try await api.fetchData(.nearbyShelters(lat: lat, lng: lng, radiusKm: radiusKm))
    }
    
    /// Fetch recommended shelters based on location and disaster type.
    func fetchRecommendedShelters(lat: Double, lng: Double, disasterType: String) async throws -> [Shelter] {
        return try await api.fetchData(.recommendedShelters(lat: lat, lng: lng, disasterType: disasterType))
    }
}

