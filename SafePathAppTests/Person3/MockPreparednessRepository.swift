import Foundation
@testable import SafePath

final class MockPreparednessRepository: PreparednessRepositoryProtocol {
    
    var shouldThrowError = false
    var itemsToReturn: [ChecklistItem] = []
    var riskProfilesToReturn: [RiskProfile] = []
    
    var savedItems: [ChecklistItem] = []
    var deletedItemIds: [String] = []
    
    func getAllItem() async throws -> [ChecklistItem] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return itemsToReturn
    }
    
    func createItem(_ item: ChecklistItem) async throws -> ChecklistItem {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        savedItems.append(item)
        itemsToReturn.append(item)
        return item
    }
    
    func updateItem(_ item: ChecklistItem) async throws -> ChecklistItem {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        savedItems.append(item)
        if let index = itemsToReturn.firstIndex(where: { $0.id == item.id }) {
            itemsToReturn[index] = item
        }
        return item
    }
    
    func deleteItem(id: String) async throws {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        deletedItemIds.append(id)
        itemsToReturn.removeAll(where: { $0.id == id })
    }
    
    func fetchRiskProfiles(lat: Double, lng: Double) async throws -> [RiskProfile] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        return riskProfilesToReturn
    }
}
