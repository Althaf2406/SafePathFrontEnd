import SwiftUI

struct EvacuationRouteWatchView: View {
    @StateObject private var wcManager = WatchConnectivityManager.shared
    
    var body: some View {
        Group {
            if let routeDict = wcManager.routeSummary,
               let route = WatchRouteSummary(from: routeDict) {
                RouteSummaryWatchView(route: route)
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "map")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("No Active Route")
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Route")
        .navigationBarTitleDisplayMode(.inline)
    }
}
