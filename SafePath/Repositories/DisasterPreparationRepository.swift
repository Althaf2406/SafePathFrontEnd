import Foundation
import Combine

protocol DisasterPreparationRepositoryProtocol {
    func fetchGuides() -> AnyPublisher<[DisasterPreparationGuide], Error>
}

/// Repository for disaster preparation guides.
final class DisasterPreparationRepository: DisasterPreparationRepositoryProtocol {
    
    func fetchGuides() -> AnyPublisher<[DisasterPreparationGuide], Error> {
        let guides = [
            DisasterPreparationGuide(
                id: UUID().uuidString,
                disasterType: "Flood",
                title: "Flood Preparation Guide",
                description: "Essential steps to take before, during, and after a flood.",
                handlingProcedures: [
                    "Evacuate immediately to higher ground if advised.",
                    "Do not walk, swim, or drive through floodwaters.",
                    "Turn off utilities at the main switches if instructed.",
                    "Disconnect electrical appliances before the flood hits."
                ],
                iconName: "cloud.heavyrain.fill"
            ),
            DisasterPreparationGuide(
                id: UUID().uuidString,
                disasterType: "Earthquake",
                title: "Earthquake Preparation Guide",
                description: "What to do to stay safe when the ground starts shaking.",
                handlingProcedures: [
                    "Drop, Cover, and Hold On.",
                    "Stay away from windows, glass, and anything that could fall.",
                    "If outdoors, move to an open area away from buildings and trees.",
                    "If in a vehicle, pull over and stay inside until shaking stops."
                ],
                iconName: "waveform.path.ecg"
            ),
            DisasterPreparationGuide(
                id: UUID().uuidString,
                disasterType: "Fire",
                title: "Wildfire Preparation Guide",
                description: "Protect yourself and your home from wildfires.",
                handlingProcedures: [
                    "Evacuate immediately if an evacuation order is given.",
                    "Keep doors and windows closed to prevent drafts.",
                    "Shut off gas valves if advised.",
                    "Keep a hose connected to outside taps."
                ],
                iconName: "flame.fill"
            )
        ]
        
        return Just(guides)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
