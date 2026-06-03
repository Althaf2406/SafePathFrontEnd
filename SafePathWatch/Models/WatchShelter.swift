import Foundation

struct WatchShelter: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let capacity: String
    let distance: String
    let address: String
    let disasterTypes: String
    
    init?(from dictionary: [String: Any]) {
        guard let name = dictionary[WCPayloadKeys.shelterName.rawValue] as? String,
              let type = dictionary[WCPayloadKeys.shelterType.rawValue] as? String,
              let capacity = dictionary[WCPayloadKeys.shelterCapacity.rawValue] as? String,
              let distance = dictionary[WCPayloadKeys.shelterDistance.rawValue] as? String,
              let address = dictionary[WCPayloadKeys.shelterAddress.rawValue] as? String,
              let disasterTypes = dictionary[WCPayloadKeys.shelterDisasterTypes.rawValue] as? String else {
            return nil
        }
        
        self.name = name
        self.type = type
        self.capacity = capacity
        self.distance = distance
        self.address = address
        self.disasterTypes = disasterTypes
    }
}
