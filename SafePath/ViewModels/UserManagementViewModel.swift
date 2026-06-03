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

    private let repository = UserRepository()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init — restore persisted session

    init() {
        restoreSession()
    }

    // MARK: - Auth Actions

    /// POST /auth/register — Registers a new user account.
    /// Currently MOCKED: simulates 1s network delay then succeeds.
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
            let user = try await repository.register(name: name, email: email, password: password, phone: phone)
            self.currentUser = user
            self.isLoggedIn  = true
            persistSession(user)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// POST /auth/login — Authenticates user and stores session.
    /// Currently MOCKED: any non-empty credentials succeed.
    func login(email: String, password: String) async {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.isEmpty else {
            errorMessage = "Please enter your email and password."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let user = try await repository.login(email: email, password: password)
            self.currentUser = user
            self.isLoggedIn  = true
            persistSession(user)
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    /// POST /auth/logout — Logs out and clears local session.
    func logout() async {
        isLoading = true

        // ── MOCK ── replace with real API call when backend is ready:
        // if let token = currentUser?.authToken {
        //     try? await repository.logout(authToken: token)
        // }
        try? await Task.sleep(nanoseconds: 500_000_000)
        // ── END MOCK ──

        clearSession()
        isLoading = false
    }

    // MARK: - Profile Actions

    /// GET /user/profile — Fetches the latest profile from backend.
    func fetchProfile() async {
        guard currentUser?.authToken != nil else { return }
        isLoading = true
        errorMessage = nil

        // ── MOCK ── replace with real API call when backend is ready:
        // currentUser = try await repository.fetchProfile(authToken: token)
        try? await Task.sleep(nanoseconds: 500_000_000)
        // No-op for mock — profile already in currentUser
        // ── END MOCK ──

        isLoading = false
    }

    /// PUT /user/profile — Updates name, phone, or profile image.
    func updateProfile(name: String? = nil, phone: String? = nil, profileImageURL: String? = nil) async {
        guard var user = currentUser else { return }
        isLoading = true
        errorMessage = nil

        // ── MOCK ── replace with real API call when backend is ready:
        // currentUser = try await repository.updateProfile(authToken: token, name: name, phone: phone, profileImageURL: profileImageURL)
        try? await Task.sleep(nanoseconds: 800_000_000)
        if let name             = name             { user.name            = name }
        if let phone            = phone            { user.phone           = phone }
        if let profileImageURL  = profileImageURL  { user.profileImageURL = profileImageURL }
        // ── END MOCK ──

        self.currentUser = user
        self.isLoading   = false
        persistSession(user)
    }

    // MARK: - Helpers

    /// Clears any displayed error message.
    func clearError() {
        errorMessage = nil
    }

    // MARK: - Session Persistence (UserDefaults)

    private let sessionKey = "safepath_current_user"

    private func persistSession(_ user: User) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: sessionKey)
        }
    }

    private func restoreSession() {
        guard let data = UserDefaults.standard.data(forKey: sessionKey),
              let user = try? JSONDecoder().decode(User.self, from: data),
              user.isAuthenticated else { return }
        self.currentUser = user
        self.isLoggedIn  = true
    }

    private func clearSession() {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        currentUser = nil
        isLoggedIn  = false
        errorMessage = nil
    }
}
