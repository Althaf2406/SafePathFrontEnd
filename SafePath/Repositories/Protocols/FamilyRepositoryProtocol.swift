import Foundation

protocol FamilyRepositoryProtocol {
    func createGroup(authToken: String, name: String) async throws -> FamilyGroup
    func fetchGroup(authToken: String, groupID: String) async throws -> FamilyGroup
    func fetchAllGroups(authToken: String) async throws -> [FamilyGroup]
    
    func inviteMember(
        authToken: String,
        groupID: String,
        phone: String?,
        email: String?
    ) async throws -> FamilyMember
    
    func removeMember(authToken: String, groupID: String, memberID: String) async throws
    
    func updateMemberStatus(
        authToken: String,
        groupID: String,
        memberID: String,
        status: FamilyMember.MemberStatus
    ) async throws -> FamilyMember
    
    func shareLocation(
        authToken: String,
        groupID: String,
        latitude: Double,
        longitude: Double
    ) async throws
    
    func fetchFamilyLocations(authToken: String, groupID: String) async throws -> [FamilyMember]
}
