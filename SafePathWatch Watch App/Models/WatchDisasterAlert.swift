import Foundation

struct WatchDisasterAlert: Identifiable {
    let id = UUID()
    let type: String
    let severity: String
    let location: String
    let timestamp: Date
    
    init?(from dictionary: [String: Any]) {
        guard let type = dictionary[WCPayloadKeys.alertType.rawValue] as? String,
              let severity = dictionary[WCPayloadKeys.alertSeverity.rawValue] as? String,
              let location = dictionary[WCPayloadKeys.alertLocation.rawValue] as? String,
              let timestampInterval = dictionary[WCPayloadKeys.alertTimestamp.rawValue] as? TimeInterval else {
            return nil
        }
        
        self.type = type
        self.severity = severity
        self.location = location
        self.timestamp = Date(timeIntervalSince1970: timestampInterval)
    }
}
