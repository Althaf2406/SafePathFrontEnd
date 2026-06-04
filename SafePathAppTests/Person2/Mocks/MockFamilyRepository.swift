import Foundation
@testable import SafePath

final class MockFamilyRepository: FamilyRepositoryProtocol {
    var shouldThrowError = false
    var groupToReturn: FamilyGroup = TestDataFactory.mockFamilyGroup()
    var groupsToReturn: [FamilyGroup] = [TestDataFactory.mockFamilyGroup()]
    var memberToReturn: FamilyMember = TestDataFactory.mockFamilyMember()
    var locationsToReturn: [FamilyMember] = [TestDataFactory.mockFamilyMember()]
    
    var didCallRemoveMember = false
    var didCallShareLocation = false

    func createGroup(authToken: String, name: String) async throws -> FamilyGroup {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return groupToReturn
    }

    func fetchGroup(authToken: String, groupID: String) async throws -> FamilyGroup {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return groupToReturn
    }

    func fetchAllGroups(authToken: String) async throws -> [FamilyGroup] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return groupsToReturn
    }

    func inviteMember(authToken: String, groupID: String, phone: String?, email: String?) async throws -> FamilyMember {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return memberToReturn
    }

    func removeMember(authToken: String, groupID: String, memberID: String) async throws {
        if shouldThrowError { throw URLError(.badServerResponse) }
        didCallRemoveMember = true
    }

    func updateMemberStatus(authToken: String, groupID: String, memberID: String, status: FamilyMember.MemberStatus) async throws -> FamilyMember {
        if shouldThrowError { throw URLError(.badServerResponse) }
        var updated = memberToReturn
        updated.status = status
        return updated
    }

    func shareLocation(authToken: String, groupID: String, latitude: Double, longitude: Double) async throws {
        if shouldThrowError { throw URLError(.badServerResponse) }
        didCallShareLocation = true
    }

    func fetchFamilyLocations(authToken: String, groupID: String) async throws -> [FamilyMember] {
        if shouldThrowError { throw URLError(.badServerResponse) }
        return locationsToReturn
    }
}
