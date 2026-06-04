import Foundation
@testable import SafePath

final class MockEmergencyStatusRepository: SafePath.EmergencyStatusRepositoryProtocol {
    var shouldThrowError = false
    var statusToReturn: EmergencyStatus = TestDataFactory.mockEmergencyStatus()
    var statusesToReturn: [EmergencyStatus] = [TestDataFactory.mockEmergencyStatus()]

    func updateStatus(status: EmergencyStatus.EmergencyStatusType, message: String?, latitude: Double?, longitude: Double?) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var updated = statusToReturn
        updated.status = status
        return updated
    }

    func fetchStatus(userID: String) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return statusToReturn
    }

    func fetchFamilyStatuses(groupID: String) async throws -> [EmergencyStatus] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return statusesToReturn
    }

    func triggerSOS(latitude: Double?, longitude: Double?, message: String?) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var sosStatus = statusToReturn
        sosStatus.isSOS = true
        return sosStatus
    }

    func resolveSOS(sosID: String) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var resolved = statusToReturn
        resolved.isSOS = false
        return resolved
    }
}
