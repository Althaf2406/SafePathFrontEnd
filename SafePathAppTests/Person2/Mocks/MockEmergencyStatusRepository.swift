import Foundation

final class MockEmergencyStatusRepository: EmergencyStatusRepositoryProtocol {
    var shouldThrowError = false
    var statusToReturn: EmergencyStatus = TestDataFactory.mockEmergencyStatus()
    var statusesToReturn: [EmergencyStatus] = [TestDataFactory.mockEmergencyStatus()]

    func updateStatus(authToken: String, status: EmergencyStatus.EmergencyStatusType, message: String?, latitude: Double?, longitude: Double?) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var updated = statusToReturn
        updated.status = status
        return updated
    }

    func fetchStatus(authToken: String, userID: String) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return statusToReturn
    }

    func fetchFamilyStatuses(authToken: String, groupID: String) async throws -> [EmergencyStatus] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return statusesToReturn
    }

    func triggerSOS(authToken: String, latitude: Double?, longitude: Double?, message: String?) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var sosStatus = statusToReturn
        sosStatus.isSOS = true
        return sosStatus
    }

    func resolveSOS(authToken: String, sosID: String) async throws -> EmergencyStatus {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var resolved = statusToReturn
        resolved.isSOS = false
        return resolved
    }
}
