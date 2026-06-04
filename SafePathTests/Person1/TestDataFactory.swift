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
            coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lng),
            capacity: capacity,
            isActive: isActive,
            contactNumber: "123",
            facilities: facilities,
            buildingLevel: buildingLevel,
            disasterTypeSupported: disasterTypeSupported,
            distanceKm: distanceKm
        )
    }
    
    static func mockDisasterAlert(
        id: String = "alert1",
        title: String = "Test Alert",
        description: String = "This is a test alert",
        severity: DisasterAlert.Severity = .high,
        type: String = "earthquake",
        magnitude: Double? = 5.0,
        instruction: String = "Evacuate",
        locationName: String = "Test City",
        timestamp: Date = Date()
    ) -> DisasterAlert {
        return DisasterAlert(
            id: id,
            title: title,
            description: description,
            severity: severity,
            type: type,
            magnitude: magnitude,
            instruction: instruction,
            coordinate: CLLocationCoordinate2D(latitude: -7.25, longitude: 112.76),
            locationName: locationName,
            affectedRadiusKm: 10.0,
            timestamp: timestamp
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
