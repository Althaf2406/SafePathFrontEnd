import SwiftUI

struct DisasterAlertWatchView: View {
    @StateObject private var wcManager = WatchConnectivityManager.shared
    
    var body: some View {
        Group {
            if let alertDict = wcManager.latestAlert,
               let alert = WatchDisasterAlert(from: alertDict) {
                
                NavigationLink(destination: AlertDetailWatchView(alert: alert)) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(alert.type)
                                .font(.headline)
                        }
                        .foregroundColor(colorForSeverity(alert.severity))
                        
                        Text(alert.location)
                            .font(.body)
                            .lineLimit(2)
                        
                        Text(alert.timestamp, style: .time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
                
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                    Text("No Active Alerts")
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Alerts")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func colorForSeverity(_ severity: String) -> Color {
        switch severity.lowercased() {
        case "low": return .yellow
        case "medium": return .orange
        case "high", "critical": return .red
        default: return .primary
        }
    }
}
