import Foundation

protocol EmergencyStatusRepositoryProtocol {
    func updateStatus(
        authToken: String,
        status: EmergencyStatus.EmergencyStatusType,
        message: String?,
        latitude: Double?,
        longitude: Double?
    ) async throws -> EmergencyStatus

    func fetchStatus(authToken: String, userID: String) async throws -> EmergencyStatus

    func fetchFamilyStatuses(authToken: String, groupID: String) async throws -> [EmergencyStatus]

    func triggerSOS(
        authToken: String,
        latitude: Double?,
        longitude: Double?,
        message: String?
    ) async throws -> EmergencyStatus

    func resolveSOS(authToken: String, sosID: String) async throws -> EmergencyStatus
}
