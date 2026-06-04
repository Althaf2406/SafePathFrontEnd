import Foundation

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

extension APIServiceProtocol {
    func send<T: Decodable>(
        _ endpoint: APIEndpoint,
        authToken: String? = nil,
        body: [String: Any]? = nil
    ) async throws -> T {
        return try await send(endpoint, authToken: authToken, body: body)
    }
    
    func sendVoid(
        _ endpoint: APIEndpoint,
        authToken: String? = nil,
        body: [String: Any]? = nil
    ) async throws {
        try await sendVoid(endpoint, authToken: authToken, body: body)
    }
}

extension APIService: APIServiceProtocol {}
