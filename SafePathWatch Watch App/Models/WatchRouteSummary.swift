import Foundation

struct WatchRouteSummary: Identifiable {
    let id = UUID()
    let destination: String
    let eta: String
    let distance: String
    
    init?(from dictionary: [String: Any]) {
        guard let destination = dictionary[WCPayloadKeys.routeDestination.rawValue] as? String,
              let eta = dictionary[WCPayloadKeys.routeETA.rawValue] as? String,
              let distance = dictionary[WCPayloadKeys.routeDistance.rawValue] as? String else {
            return nil
        }
        
        self.destination = destination
        self.eta = eta
        self.distance = distance
    }
}
