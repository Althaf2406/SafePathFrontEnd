import Foundation
import CoreLocation

@testable import SafePath

struct TestDataFactory {
    
    static func mockShelter(
        id: Int = 1,
        name: String = "Test Shelter",
        address: String = "123 Safe St",
        latitude: Double = -7.250445,
        longitude: Double = 112.768845,
        capacity: Int = 100,
        availableCapacity: Int? = 80,
        contact: String? = "123",
        facilities: [String] = [],
        shelterType: ShelterType = .building,
        disasterTypeSupported: [String] = [],
        isOpenArea: Bool = false,
        buildingLevel: Int = 1,
        isActive: Bool = true,
        distanceKm: Double? = 1.5,
        recommendationScore: Int? = 0
    ) -> Shelter {
        Shelter(
            id: id,
            name: name,
            address: address,
            latitude: latitude,
            longitude: longitude,
            capacity: capacity,
            availableCapacity: availableCapacity,
            contact: contact,
            facilities: facilities,
            shelterType: shelterType,
            disasterTypeSupported: disasterTypeSupported,
            isOpenArea: isOpenArea,
            buildingLevel: buildingLevel,
            isActive: isActive,
            distanceKm: distanceKm,
            recommendationScore: recommendationScore
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
        instruction: String = "Evacuate immediately.",
        timestamp: String = "2026-06-04T10:00:00.000Z",
        source: String = "BMKG",
        sourceUrl: String = "https://data.bmkg.go.id",
        tsunamiPotential: Bool? = false,
        depth: String? = "10 km",
        feltDescription: String? = "II-III MMI",
        distanceKm: Double? = 10.0,
        isNearby: Bool? = true
    ) -> DisasterAlert {
        DisasterAlert(
            id: id,
            type: type,
            severity: severity,
            magnitude: magnitude,
            latitude: latitude,
            longitude: longitude,
            locationName: locationName,
            instruction: instruction,
            timestamp: timestamp,
            source: source,
            sourceUrl: sourceUrl,
            tsunamiPotential: tsunamiPotential,
            depth: depth,
            feltDescription: feltDescription,
            distanceKm: distanceKm,
            isNearby: isNearby
        )
    }
    
    static func mockUserLocation(
        latitude: Double = -7.250000,
        longitude: Double = 112.760000
    ) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    static func mockEvacuationRoute(
        id: String = "route1",
        shelterId: String = "1",
        shelterName: String = "Test Shelter",
        distanceMeters: Double = 1500,
        expectedTravelTime: TimeInterval = 600,
        safetyScore: Double = 0.9
    ) -> EvacuationRoute {
        EvacuationRoute(
            id: id,
            shelterId: shelterId,
            shelterName: shelterName,
            distanceMeters: distanceMeters,
            expectedTravelTime: expectedTravelTime,
            safetyScore: safetyScore,
            mkRoute: nil,
            customPolyline: nil
        )
    }
    
    // MARK: - Person 3
    
    static func mockFirstAidGuide(
        title: String = "Test Guide",
        category: String = "test",
        shortDescription: String = "This is a test description."
    ) -> FirstAidGuide {
        FirstAidGuide(
            id: UUID().uuidString,
            title: title,
            category: category,
            shortDescription: shortDescription,
            steps: [],
            iconName: "heart",
            requiredKit: [],
            detailedSteps: []
        )
    }
    
    static func mockChecklistItem(
        name: String = "Test Item",
        category: KitCategory = .food,
        isChecked: Bool = false,
        disasterType: String = "All"
    ) -> ChecklistItem {
        ChecklistItem(
            id: UUID().uuidString,
            name: name,
            isChecked: isChecked,
            category: category,
            quantity: 1,
            priority: .high,
            disasterType: disasterType
        )
    }
    
    static func mockDisasterPreparationGuide(
        disasterType: String = "Flood",
        title: String = "Flood Prep"
    ) -> DisasterPreparationGuide {
        DisasterPreparationGuide(
            id: UUID().uuidString,
            disasterType: disasterType,
            title: title,
            description: "Test description",
            handlingProcedures: ["Step 1", "Step 2"],
            iconName: "cloud"
        )
    }
    
    static func mockRiskProfile(
        type: String = "Flood",
        level: RiskLevel = .high
    ) -> RiskProfile {
        RiskProfile(
            id: UUID().uuidString,
            type: type,
            iconName: "cloud",
            level: level
        )
    }
}
