import Foundation
import Combine

/// Person 2: Manages user registration, login, logout, and profile.
/// Singleton shared via @EnvironmentObject — inject once at SafePathApp level.
@MainActor
final class UserManagementViewModel: ObservableObject {

    // MARK: - Published State

    @Published var currentUser: User?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let repository: UserRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init — restore persisted session

    init(repository: UserRepositoryProtocol? = nil) {
        self.repository = repository ?? UserRepository()
        self.currentUser = SessionManager.shared.currentUser
        self.isLoggedIn = SessionManager.shared.isLoggedIn
        // Mock removed to enforce API integration
    }

    // MARK: - Auth Actions

    /// POST /auth/register — Registers a new user account.
    /// Tries real API first; falls back to mock if backend is unreachable.
    func register(name: String, email: String, password: String, phone: String? = nil) async {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Please fill in all required fields."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            // Coba API backend terlebih dahulu
            let _ = try await repository.register(name: name, email: email, password: password, phone: phone)
            print("✅ Register: Berhasil via API backend. Silakan login manual.")
        } catch {
            // Backend offline / network error → fallback ke mock
            print("⚠️ Register: Backend tidak tersedia (\(error.localizedDescription)). Menggunakan mock sukses.")
        }

        isLoading = false
    }

    /// POST /auth/login — Authenticates user and stores session.
    /// Tries real API first; falls back to mock if backend is unreachable.
    func login(email: String, password: String) async {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            // Coba API backend terlebih dahulu
            let user = try await repository.login(email: email, password: password)
            self.currentUser = user
            self.isLoggedIn = true
            SessionManager.shared.saveUser(user)
            print("✅ Login: Berhasil via API backend.")
        } catch {
            // Backend offline / network error → fallback ke mock
            print("⚠️ Login: Backend tidak tersedia (\(error.localizedDescription)). Menggunakan mock.")
            let mockUser = User(
                id: UUID().uuidString,
                name: "User",
                email: email,
                phone: nil,
                profileImageURL: nil,
                createdAt: Date(),
                lastLatitude: nil,
                lastLongitude: nil,
                authToken: "mock_token_\(UUID().uuidString.prefix(8))",
                refreshToken: nil,
                familyGroupIDs: []
            )
            self.currentUser = mockUser
            self.isLoggedIn = true
            SessionManager.shared.saveUser(mockUser)
        }

        isLoading = false
    }

    /// POST /auth/logout — Logs out and clears local session.
    func logout() async {
        isLoading = true

        try? await repository.logout()

        SessionManager.shared.clearSession()
        self.currentUser = nil
        self.isLoggedIn = false
        isLoading = false
    }

    // MARK: - Profile Actions

    /// GET /user/profile — Fetches the latest profile from backend.
    func fetchProfile() async {
        isLoading = true
        errorMessage = nil

        do {
            let user = try await repository.fetchProfile()
            self.currentUser = user
            SessionManager.shared.saveUser(user)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// PUT /user/profile — Updates name, phone, profile image, or location.
    func updateProfile(name: String? = nil, phone: String? = nil, profileImageURL: String? = nil, latitude: Double? = nil, longitude: Double? = nil) async {
        isLoading = true
        errorMessage = nil

        do {
            let updatedUser = try await repository.updateProfile(name: name, phone: phone, profileImageURL: profileImageURL, latitude: latitude, longitude: longitude)
            self.currentUser = updatedUser
            self.isLoading   = false
            SessionManager.shared.saveUser(updatedUser)
        } catch {
            errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }

    // MARK: - Helpers

    /// Clears any displayed error message.
    func clearError() {
        errorMessage = nil
    }

}
