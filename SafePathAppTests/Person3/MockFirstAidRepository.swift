import Foundation
import Combine
@testable import SafePath

final class MockFirstAidRepository: FirstAidRepositoryProtocol {
    
    var shouldThrowError = false
    var guidesToReturn: [FirstAidGuide] = []
    
    func fetchGuides() -> AnyPublisher<[FirstAidGuide], Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        return Just(guidesToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

//
