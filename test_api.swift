import Foundation

struct ShelterResponse: Decodable {
    let success: Bool
    let data: [Shelter]
}

enum ShelterType: String, Codable {
    case building = "building"
    case openArea = "open_area"
    case verticalShelter = "vertical_shelter"
}

struct Shelter: Codable {
    let id: Int
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let capacity: Int
    let availableCapacity: Int?
    let contact: String?
    let facilities: [String]
    let shelterType: ShelterType
    let disasterTypeSupported: [String]
    let isOpenArea: Bool
    let buildingLevel: Int
    let isActive: Bool
}

let semaphore = DispatchSemaphore(value: 0)

var request = URLRequest(url: URL(string: "http://127.0.0.1:3000/api/shelters")!)
request.httpMethod = "GET"

let task = URLSession.shared.dataTask(with: request) { data, response, error in
    defer { semaphore.signal() }
    guard let data = data else {
        print("No data")
        return
    }
    do {
        let decoder = JSONDecoder()
        let res = try decoder.decode(ShelterResponse.self, from: data)
        print("Successfully decoded \(res.data.count) shelters")
    } catch {
        print("Decoding Error: \(error)")
    }
}
task.resume()
semaphore.wait()
