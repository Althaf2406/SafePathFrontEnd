import SwiftUI

struct NearestShelterWatchView: View {
    @StateObject private var wcManager = WatchConnectivityManager.shared
    
    var body: some View {
        Group {
            if let shelterDict = wcManager.nearestShelter,
               let shelter = WatchShelter(from: shelterDict) {
                
                VStack(spacing: 8) {
                    NavigationLink(destination: ShelterDetailWatchView(shelter: shelter)) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(shelter.name)
                                .font(.headline)
                                .lineLimit(2)
                            
                            HStack {
                                Image(systemName: "location.fill")
                                Text(shelter.distance)
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                            
                            Text("Capacity: \(shelter.capacity)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                    
                    Button(action: {
                        // Action to trigger navigation on iPhone could go here
                        // For watch-only display, we just show the view
                    }) {
                        HStack {
                            Image(systemName: "figure.run")
                            Text("Navigate")
                                .fontWeight(.bold)
                        }
                    }
                    .tint(.blue)
                }
                
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "house")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("No Shelter Found")
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Nearest")
        .navigationBarTitleDisplayMode(.inline)
    }
}
