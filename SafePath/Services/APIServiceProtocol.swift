import Foundation
@testable import SafePath

protocol APIServiceProtocol {
    func send<T: Decodable>(
        _ endpoint: APIEndpoint,
        authToken: String?,
        body: [String: Any]?
    ) async throws -> T
    
    func sendVoid(
        _ endpoint: APIEndpoint,
        authToken: String?,
        body: [String: Any]?
    ) async throws
}

extension APIService: APIServiceProtocol {}
