import SwiftUI
import Combine

@main
struct SafePathApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject var preparednessViewModel = PreparednessViewModel()
    @StateObject var userVM = UserManagementViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(locationService)
                .environmentObject(preparednessViewModel)
                .environmentObject(userVM)
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
