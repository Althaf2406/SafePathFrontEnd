import SwiftUI
import Combine

@main
struct SafePathApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject private var userVM = UserManagementViewModel()
    @StateObject var preparednessViewModel = PreparednessViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(locationService)
                .environmentObject(userVM)
                .environmentObject(preparednessViewModel)
                .onAppear {
                    locationService.requestPermission()
                }
        }
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
