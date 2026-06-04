import Foundation
import Combine
@testable import SafePath

final class MockDisasterPreparationRepository: DisasterPreparationRepositoryProtocol {
    
    var shouldThrowError = false
    var guidesToReturn: [DisasterPreparationGuide] = []
    
    func fetchGuides() -> AnyPublisher<[DisasterPreparationGuide], Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        return Just(guidesToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
