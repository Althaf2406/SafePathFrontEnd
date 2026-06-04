import Foundation
@testable import SafePath

final class MockUserRepository: UserRepositoryProtocol {
    var shouldThrowError = false
    var userToReturn: User = TestDataFactory.mockUser()
    var lastUpdatedProfile: User?
    var didCallLogout = false

    func register(name: String, email: String, password: String, phone: String?) async throws -> User {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return userToReturn
    }

    func login(email: String, password: String) async throws -> User {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return userToReturn
    }

    func logout(authToken: String) async throws {
        if shouldThrowError { throw URLError(.badServerResponse) }
        didCallLogout = true
    }

    func fetchProfile(authToken: String) async throws -> User {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return userToReturn
    }

    func updateProfile(
        authToken: String,
        name: String?,
        phone: String?,
        profileImageURL: String?,
        latitude: Double?,
        longitude: Double?
    ) async throws -> User {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var updated = userToReturn
        if let name = name { updated.name = name }
        if let lat = latitude { updated.lastLatitude = lat }
        if let lng = longitude { updated.lastLongitude = lng }
        lastUpdatedProfile = updated
        return updated
    }
}
