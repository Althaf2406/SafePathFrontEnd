import SwiftUI

struct RouteSummaryWatchView: View {
    let route: WatchRouteSummary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Destination")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(route.destination)
                    .font(.headline)
                    .lineLimit(2)
            }
            
            HStack(spacing: 16) {
                VStack(alignment: .leading) {
                    Text("ETA")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(route.eta)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
                
                VStack(alignment: .leading) {
                    Text("Distance")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(route.distance)
                        .font(.title3)
                        .fontWeight(.bold)
                }
            }
            
            Spacer()
        }
        .padding()
    }
}
