import SwiftUI

struct WatchHomeView: View {
    @StateObject private var wcManager = WatchConnectivityManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: DisasterAlertWatchView()) {
                    VStack(alignment: .leading) {
                        Label("Disaster Alerts", systemImage: "exclamationmark.triangle")
                            .font(.headline)
                            .foregroundColor(.red)
                        if let _ = wcManager.latestAlert {
                            Text("New Alert Received")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                NavigationLink(destination: NearestShelterWatchView()) {
                    Label("Nearest Shelter", systemImage: "house.fill")
                        .font(.headline)
                        .foregroundColor(.green)
                        .padding(.vertical, 4)
                }
                
                NavigationLink(destination: EvacuationRouteWatchView()) {
                    Label("Evacuation Route", systemImage: "figure.run")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.vertical, 4)
                }
            }
            .navigationTitle("SafePath")
        }
    }
}
