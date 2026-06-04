import Foundation

protocol UserRepositoryProtocol {
    func register(name: String, email: String, password: String, phone: String?) async throws -> User
    func login(email: String, password: String) async throws -> User
    func logout(authToken: String) async throws
    func fetchProfile(authToken: String) async throws -> User
    func updateProfile(
        authToken: String,
        name: String?,
        phone: String?,
        profileImageURL: String?,
        latitude: Double?,
        longitude: Double?
    ) async throws -> User
}
