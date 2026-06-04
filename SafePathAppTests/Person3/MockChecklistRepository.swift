import Foundation
import Combine
@testable import SafePath

final class MockChecklistRepository: ChecklistRepositoryProtocol {
    
    var shouldThrowError = false
    var customItemsToReturn: [ChecklistItem] = []
    var savedItems: [ChecklistItem] = []
    var deletedItemIds: [String] = []
    
    func fetchCustomItems() -> AnyPublisher<[ChecklistItem], Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        return Just(customItemsToReturn)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func fetchItems(forDisasterType disasterType: String) -> AnyPublisher<[ChecklistItem], Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        let filtered = customItemsToReturn.filter { $0.disasterType == disasterType || $0.disasterType == "All" }
        return Just(filtered)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveCustomItem(_ item: ChecklistItem) -> AnyPublisher<Void, Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        savedItems.append(item)
        if let index = customItemsToReturn.firstIndex(where: { $0.id == item.id }) {
            customItemsToReturn[index] = item
        } else {
            customItemsToReturn.append(item)
        }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func deleteCustomItem(id: String) -> AnyPublisher<Void, Error> {
        if shouldThrowError {
            return Fail(error: URLError(.badServerResponse))
                .eraseToAnyPublisher()
        }
        deletedItemIds.append(id)
        customItemsToReturn.removeAll(where: { $0.id == id })
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

//
