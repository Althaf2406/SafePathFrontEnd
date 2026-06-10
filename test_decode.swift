import Foundation

let jsonStr = """
{"success":true,"count":8,"data":[{"id":1,"name":"Universitas Airlangga Kampus C","address":"Mulyorejo, Surabaya","latitude":-7.2677,"longitude":112.7847,"capacity":800,"availableCapacity":750,"contact":"081234567890","facilities":["Toilet","Air Bersih","Area Parkir"],"shelterType":"building","disasterTypeSupported":["flood","earthquake"],"isOpenArea":false,"buildingLevel":3,"isActive":true,"createdAt":"2026-06-10T05:28:44.802Z","updatedAt":"2026-06-10T05:28:44.802Z"},{"id":2,"name":"GOR Bung Tomo","address":"Benowo, Surabaya","latitude":-7.2239,"longitude":112.6081,"capacity":1200,"availableCapacity":1100,"contact":"081234567891","facilities":["Toilet","Area Luas","Parkir"],"shelterType":"open_area","disasterTypeSupported":["earthquake"],"isOpenArea":true,"buildingLevel":1,"isActive":true,"createdAt":"2026-06-10T05:28:44.802Z","updatedAt":"2026-06-10T05:28:44.802Z"}]}
"""

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

struct ShelterResponse: Codable {
    let success: Bool
    let data: [Shelter]
}

do {
    let data = jsonStr.data(using: .utf8)!
    let decoder = JSONDecoder()
    let res = try decoder.decode(ShelterResponse.self, from: data)
    print("Success: \(res.data.count) shelters")
} catch {
    print("Error: \(error)")
}
