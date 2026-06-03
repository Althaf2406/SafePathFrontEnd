import Foundation
import Combine

/// Person 3: Repository for first aid guide content.
final class FirstAidRepository {
    
    /// Simulates fetching first aid guides from backend or local bundle.
    func fetchGuides() -> AnyPublisher<[FirstAidGuide], Error> {
        let guides = [
            FirstAidGuide(
                id: UUID().uuidString,
                title: "CPR & Choking",
                category: "cpr",
                shortDescription: "Step-by-step cardiopulmonary resuscitation and Heimlich maneuver.",
                steps: [],
                iconName: "heart.fill",
                requiredKit: [
                    FirstAidKitItem(id: UUID().uuidString, name: "Face Shield", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Gloves", status: .inKit)
                ],
                detailedSteps: []
            ),
            FirstAidGuide(
                id: UUID().uuidString,
                title: "Severe Bleeding",
                category: "bleeding",
                shortDescription: "Direct pressure and tourniquet application guidelines.",
                steps: [],
                iconName: "drop.fill",
                requiredKit: [
                    FirstAidKitItem(id: UUID().uuidString, name: "Gauze", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Bandages", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Tourniquet", status: .inKit)
                ],
                detailedSteps: []
            ),
            FirstAidGuide(
                id: UUID().uuidString,
                title: "Burns",
                category: "burns",
                shortDescription: "Cooling techniques and dressing for thermal and chemical burns.",
                steps: [],
                iconName: "flame.fill",
                requiredKit: [
                    FirstAidKitItem(id: UUID().uuidString, name: "Burn Gel", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Non-stick Dressing", status: .inKit)
                ],
                detailedSteps: []
            ),
            FirstAidGuide(
                id: UUID().uuidString,
                title: "Broken Bone",
                category: "fractures",
                shortDescription: "Immobilization and splinting for suspected fractures.",
                steps: [],
                iconName: "person.crop.circle.fill.badge.plus",
                requiredKit: [
                    FirstAidKitItem(id: UUID().uuidString, name: "Bandage", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Clean Cloth", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Rigid Splint Material", status: .missing)
                ],
                detailedSteps: [
                    FirstAidStep(id: UUID().uuidString, title: "Keep the person still", description: "Do not move the victim unless they are in immediate danger. Moving can cause further injury."),
                    FirstAidStep(id: UUID().uuidString, title: "Do not realign the bone", description: "Never attempt to push a bone back into place. Leave it exactly as you found it."),
                    FirstAidStep(id: UUID().uuidString, title: "Control any bleeding", description: "If the bone has broken the skin, apply gentle pressure around (not directly on) the bone with a clean cloth."),
                    FirstAidStep(id: UUID().uuidString, title: "Apply a cold pack", description: "Wrap an ice pack or cold item in a cloth and apply to the area for up to 20 minutes to reduce swelling.")
                ]
            ),
            FirstAidGuide(
                id: UUID().uuidString,
                title: "Sprain or Strain",
                category: "sprain",
                shortDescription: "R.I.C.E method for joint and muscle injuries.",
                steps: [],
                iconName: "figure.walk",
                requiredKit: [
                    FirstAidKitItem(id: UUID().uuidString, name: "Ice Pack", status: .inKit),
                    FirstAidKitItem(id: UUID().uuidString, name: "Elastic Bandage", status: .inKit)
                ],
                detailedSteps: []
            )
        ]
        
        return Just(guides)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
