import Foundation
import Combine

/// Person 2: Manages family group operations.
@MainActor
final class FamilySafetyViewModel: ObservableObject {

    // MARK: - Published State

    @Published var familyGroup: FamilyGroup?
    @Published var members: [FamilyMember] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let repository: FamilyRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: FamilyRepositoryProtocol? = nil) {
        self.repository = repository ?? FamilyRepository()
    }

    // MARK: - Group Actions

    /// POST /family/group — Creates a new family group.
    /// Tries real API first; falls back to a local mock if backend fails.
    func createGroup(name: String) async {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter a group name."
            return
        }
        isLoading = true
        errorMessage = nil
        do {
            familyGroup = try await repository.createGroup(name: name)
            members = familyGroup?.members ?? []
            print("✅ createGroup: Berhasil via API backend.")
        } catch {
            // Backend tidak tersedia atau token tidak valid → buat mock lokal
            print("⚠️ createGroup: API gagal (\(error.localizedDescription)). Menggunakan mock.")
            let mockGroup = FamilyGroup(
                id: UUID().uuidString,
                name: name.trimmingCharacters(in: .whitespaces),
                members: [],
                inviteCode: generateMockInviteCode(),
                adminUserID: UUID().uuidString,
                maxMembers: 20,
                isActive: true
            )
            familyGroup = mockGroup
            members = mockGroup.members
        }
        isLoading = false
    }

    /// Generates a random 8-character invite code (mock fallback).
    private func generateMockInviteCode() -> String {
        let chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String((0..<8).map { _ in chars.randomElement()! })
    }

    /// GET /family/group/:id — Fetches group details and refreshes members list.
    func fetchGroup(groupID: String) async {
        isLoading = true
        errorMessage = nil
        do {
            familyGroup = try await repository.fetchGroup(groupID: groupID)
            members = familyGroup?.members ?? []
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Member Actions

    /// POST /family/group/:id/invite — Invites a member by phone or email.
    func inviteMember(phone: String? = nil, email: String? = nil) async {
        guard let groupID = familyGroup?.id else { return }
        isLoading = true
        errorMessage = nil
        do {
            let newMember = try await repository.inviteMember(
                groupID: groupID,
                phone: phone,
                email: email
            )
            members.append(newMember)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// DELETE /family/group/:id/member/:memberId — Removes a member (admin only).
    func removeMember(groupID: String? = nil, memberID: String) async {
        guard let targetGroupID = groupID ?? familyGroup?.id else { return }
        isLoading = true
        errorMessage = nil
        do {
            try await repository.removeMember(groupID: targetGroupID, memberID: memberID)
            members.removeAll { $0.id == memberID }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// PUT /family/group/:id/member/:memberId/status — Updates a member's safety status.
    func updateMemberStatus(memberID: String, status: FamilyMember.MemberStatus) async {
        guard let groupID = familyGroup?.id else { return }
        isLoading = true
        errorMessage = nil
        do {
            let updated = try await repository.updateMemberStatus(
                groupID: groupID,
                memberID: memberID,
                status: status
            )
            if let idx = members.firstIndex(where: { $0.id == memberID }) {
                members[idx] = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Location Actions

    /// POST /family/location — Shares current user's location with the family group.
    func shareLocation(latitude: Double, longitude: Double) async {
        guard let groupID = familyGroup?.id else { return }
        errorMessage = nil
        do {
            try await repository.shareLocation(
                groupID: groupID,
                latitude: latitude,
                longitude: longitude
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// GET /family/group/:id/locations — Refreshes all member locations.
    func fetchFamilyLocations(groupID: String? = nil) async {
        guard let targetGroupID = groupID ?? familyGroup?.id else { return }
        isLoading = true
        errorMessage = nil
        do {
            members = try await repository.fetchFamilyLocations(groupID: targetGroupID)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    // MARK: - Helpers

    /// Clears any displayed error message.
    func clearError() {
        errorMessage = nil
    }
}

//tstst
