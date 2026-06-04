import Foundation
@testable import SafePath

final class MockAPIService: APIServiceProtocol {
    var shouldThrowError = false
    var responseToReturn: Any?

    func send<T>(
        _ endpoint: APIEndpoint,
        authToken: String?,
        body: [String : Any]?
    ) async throws -> T where T : Decodable {
        if shouldThrowError { throw URLError(.badServerResponse) }
        guard let response = responseToReturn as? T else {
            throw URLError(.cannotDecodeContentData)
        }
        return response
    }

    func sendVoid(
        _ endpoint: APIEndpoint,
        authToken: String?,
        body: [String : Any]?
    ) async throws {
        if shouldThrowError { throw URLError(.badServerResponse) }
    }
}
