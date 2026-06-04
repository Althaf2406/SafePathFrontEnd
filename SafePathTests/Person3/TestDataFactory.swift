import Foundation
@testable import SafePath

struct TestDataFactory {
    
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
