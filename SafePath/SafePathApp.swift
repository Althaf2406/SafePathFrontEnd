import SwiftUI
import Combine

@main
struct SafePathApp: App {
    @StateObject private var locationService = LocationService()
    @StateObject var preparednessViewModel = PreparednessViewModel()

    var body: some Scene {
        WindowGroup {
            AppRouter()
                .environmentObject(locationService)
                .environmentObject(preparednessViewModel)
                .onAppear {
                    locationService.requestPermission()
                }
        }
    }
}
