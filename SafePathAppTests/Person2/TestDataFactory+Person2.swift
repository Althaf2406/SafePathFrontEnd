import Foundation
@testable import SafePath
import Testing

extension TestDataFactory {
    static func mockUser(
        id: String = "test-user-1",
        name: String = "Test User",
        email: String = "test@user.com",
        lastLatitude: Double = 0.0,
        lastLongitude: Double = 0.0,
        authToken: String = "mock-token",
        familyGroupIDs: [String] = []
    ) -> User {
        return User(
            id: id,
            name: name,
            email: email,
            lastLatitude: lastLatitude,
            lastLongitude: lastLongitude,
            authToken: authToken,
            familyGroupIDs: familyGroupIDs
        )
    }

    static func mockFamilyMember(
        id: String = "member-1",
        name: String = "Member Name",
        role: FamilyMember.MemberRole = .member,
        status: FamilyMember.MemberStatus = .safe,
        isSafe: Bool = true,
        lastLatitude: Double? = nil,
        lastLongitude: Double? = nil
    ) -> FamilyMember {
        // Assuming standard properties for FamilyMember
        return FamilyMember(
            id: id,
            name: name,
            phone: nil,
            isSafe: isSafe,
            lastLatitude: lastLatitude,
            lastLongitude: lastLongitude,
            lastUpdated: nil,
            role: role,
            status: status,
            avatarURL: nil,
            deviceToken: nil
        )
    }

    static func mockFamilyGroup(
        id: String = "group-1",
        name: String = "Test Group",
        members: [FamilyMember] = [mockFamilyMember()]
    ) -> FamilyGroup {
        // Assuming standard properties for FamilyGroup
        return FamilyGroup(
            id: id,
            name: name,
            members: members,
            createdAt: Date(),
            inviteCode: "ABCDEFGH",
            adminUserID: "admin-1",
            maxMembers: 10,
            isActive: true
        )
    }

    static func mockEmergencyStatus(
        id: String = "status-1",
        userID: String = "user-1",
        status: EmergencyStatus.EmergencyStatusType = .safe,
        isSOS: Bool = false
    ) -> EmergencyStatus {
        // Assuming standard properties for EmergencyStatus
        return EmergencyStatus(
            id: id,
            userID: userID,
            status: status,
            message: nil,
            latitude: nil,
            longitude: nil,
            updatedAt: Date(),
            isSOS: isSOS,
            escalationLevel: .none,
            responderID: nil,
            responderName: nil,
            resolvedAt: nil
        )
    }
}
