import Foundation
import Testing
@testable import SafePath


@Suite("UserManagement ViewModel Tests")
@MainActor
struct UserManagementViewModelTests {
    
    init() {
        SessionManager.shared.clearSession()
    }

    @Test("Fungsi: register() - Skenario Berhasil")
    func testRegisterSuccess() async {
        let mockRepo = MockUserRepository()
        let vm = UserManagementViewModel(repository: mockRepo)
        
        await vm.register(name: "Test", email: "test@test.com", password: "password")
        
        #expect(vm.currentUser != nil)
        #expect(vm.isLoggedIn == true)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: register() - Skenario Gagal Validasi")
    func testRegisterValidationFailure() async {
        let mockRepo = MockUserRepository()
        let vm = UserManagementViewModel(repository: mockRepo)
        
        // Empty password should fail validation
        await vm.register(name: "Test", email: "test@test.com", password: "")
        
        #expect(vm.errorMessage != nil)
        #expect(vm.isLoggedIn == false)
    }

    @Test("Fungsi: login() - Skenario Berhasil")
    func testLoginSuccess() async {
        let mockRepo = MockUserRepository()
        let vm = UserManagementViewModel(repository: mockRepo)
        
        await vm.login(email: "test@test.com", password: "password")
        
        #expect(vm.currentUser != nil)
        #expect(vm.isLoggedIn == true)
        #expect(vm.errorMessage == nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: login() - Skenario Gagal")
    func testLoginFailure() async {
        let mockRepo = MockUserRepository()
        mockRepo.shouldThrowError = true
        let vm = UserManagementViewModel(repository: mockRepo)
        
        await vm.login(email: "test@test.com", password: "password")
        
        #expect(vm.errorMessage != nil)
        #expect(vm.isLoading == false)
    }

    @Test("Fungsi: logout() - Skenario Berhasil")
    func testLogoutSuccess() async {
        let mockRepo = MockUserRepository()
        let vm = UserManagementViewModel(repository: mockRepo)
        
        // First mock a logged-in state
        vm.currentUser = TestDataFactory.mockUser()
        vm.isLoggedIn = true
        
        await vm.logout()
        
        #expect(vm.currentUser == nil)
        #expect(vm.isLoggedIn == false)
        #expect(mockRepo.didCallLogout == true)
    }

    @Test("Fungsi: updateProfile() - Skenario Berhasil")
    func testUpdateProfileSuccess() async {
        let mockRepo = MockUserRepository()
        let vm = UserManagementViewModel(repository: mockRepo)
        vm.currentUser = TestDataFactory.mockUser(authToken: "token")
        
        await vm.updateProfile(name: "Updated Name", latitude: -7.0, longitude: 112.0)
        
        #expect(vm.currentUser?.name == "Updated Name")
        #expect(vm.errorMessage == nil)
        #expect(mockRepo.lastUpdatedProfile?.name == "Updated Name")
    }
}
