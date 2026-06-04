import Foundation
import CoreLocation
import MapKit
@testable import SafePath


struct TestDataFactory {
    static func mockShelter(
        id: Int = 1,
        name: String = "Test Shelter",
        address: String = "123 Safe St",
        lat: Double = -7.250445,
        lng: Double = 112.768845,
        capacity: Int = 100,
        isActive: Bool = true,
        buildingLevel: Int = 1,
        facilities: [String] = [],
        distanceKm: Double? = 1.5,
        disasterTypeSupported: [String] = []
    ) -> Shelter {
        return Shelter(
            id: id,
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            capacity: capacity,
            availableCapacity: capacity,
            contact: "123",
            facilities: facilities,
            shelterType: .building,
            disasterTypeSupported: disasterTypeSupported,
            isOpenArea: false,
            buildingLevel: buildingLevel,
            isActive: isActive,
            distanceKm: distanceKm,
            recommendationScore: 0
        )
    }
    
    static func mockDisasterAlert(
        id: String = "alert1",
        type: String = "earthquake",
        severity: AlertSeverity = .high,
        magnitude: Double = 5.0,
        latitude: Double = -7.25,
        longitude: Double = 112.76,
        locationName: String = "Test City",
        instruction: String = "Evacuate",
        timestamp: String = "2024-12-01T08:30:00.000Z"
    ) -> DisasterAlert {
        return DisasterAlert(
            id: id,
            type: type,
            severity: severity,
            magnitude: magnitude,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            instruction: instruction,
            timestamp: timestamp,
            source: "BMKG",
            sourceUrl: "https://data.bmkg.go.id",
            tsunamiPotential: false,
            depth: "10 km",
            feltDescription: nil,
            distanceKm: 10.0,
            isNearby: true
        )
    }
    
    static func mockEvacuationRoute() -> EvacuationRoute {
        return EvacuationRoute(
            id: "route1",
            shelterId: "1",
            shelterName: "Test Shelter",
            distanceMeters: 1500,
            expectedTravelTime: 600,
            safetyScore: 0.9,
            mkRoute: nil // We omit mkRoute since MKRoute is hard to mock purely in tests without Objective-C tricks
        )
    }
    
    static func mockUserLocation() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: -7.250000, longitude: 112.760000)
    }
}
