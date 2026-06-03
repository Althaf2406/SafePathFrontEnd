import SwiftUI

struct AlertDetailWatchView: View {
    let alert: WatchDisasterAlert
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(alert.type)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(colorForSeverity(alert.severity))
                
                Divider()
                
                DetailRow(title: "Severity", value: alert.severity)
                DetailRow(title: "Location", value: alert.location)
                
                VStack(alignment: .leading) {
                    Text("Time")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(alert.timestamp, style: .date)
                    Text(alert.timestamp, style: .time)
                }
            }
            .padding(.horizontal)
        }
        .navigationTitle("Details")
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

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
