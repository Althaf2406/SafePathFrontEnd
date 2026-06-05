import SwiftUI
import Combine
import SwiftData

@main
struct SafePathApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var userVM = UserManagementViewModel()
    @StateObject var preparednessViewModel = PreparednessViewModel()
    @StateObject private var emergencyVM = EmergencyStatusViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(locationService)
                .environmentObject(userVM)
                .environmentObject(preparednessViewModel)
                .environmentObject(emergencyVM)
                .onAppear {
                    locationService.requestPermission()
                }
        }
        .modelContainer(SharedModelContainer.shared.container)
    }
}

/// RootView: decides whether to show Login or the main TabView
/// based on UserManagementViewModel.isLoggedIn
struct RootView: View {
    @EnvironmentObject var userVM: UserManagementViewModel

    var body: some View {
        if userVM.isLoggedIn {
            AppRouter()
        } else {
            LoginView()
        }
    }
}
