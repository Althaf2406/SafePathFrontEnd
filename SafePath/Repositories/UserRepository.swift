import Foundation

/// Person 2: Repository for user API calls.
/// Connects to Express backend auth & profile endpoints via APIService.
final class UserRepository: UserRepositoryProtocol {

    private let api: APIServiceProtocol

    init(api: APIServiceProtocol = APIService.shared) {
        self.api = api
    }

    // MARK: - Auth Endpoints

    /// POST /auth/register
    func register(name: String, email: String, password: String, phone: String?) async throws -> User {
        var body: [String: Any] = [
            "name":     name,
            "email":    email,
            "password": password
        ]
        if let phone = phone { body["phone"] = phone }

        return try await api.send(.register, body: body)
    }

    /// POST /auth/login
    func login(email: String, password: String) async throws -> User {
        let body: [String: Any] = [
            "email":    email,
            "password": password
        ]
        return try await api.send(.login, body: body)
    }

    /// POST /auth/logout
    func logout(authToken: String) async throws {
        try await api.sendVoid(.logout, authToken: authToken)
    }

    // MARK: - Profile Endpoints

    /// GET /user/profile
    func fetchProfile(authToken: String) async throws -> User {
        return try await api.send(.userProfile, authToken: authToken)
    }

    func updateProfile(
        authToken: String,
        name: String? = nil,
        phone: String? = nil,
        profileImageURL: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) async throws -> User {
        var body: [String: Any] = [:]
        if let name            = name            { body["name"]              = name }
        if let phone           = phone           { body["phone"]             = phone }
        if let profileImageURL = profileImageURL { body["profile_image_url"] = profileImageURL }
        if let latitude        = latitude        { body["latitude"]          = latitude }
        if let longitude       = longitude       { body["longitude"]         = longitude }

        return try await api.send(.updateProfile, authToken: authToken, body: body)
    }
}
