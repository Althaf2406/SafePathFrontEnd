import Foundation
import Testing

@testable import SafePath

@Suite("NotificationViewModel Tests")
@MainActor
struct NotificationViewModelTests {

    @Test("Fungsi: receive(_:) - Menambah Notifikasi dan Mengupdate unreadCount")
    func testReceiveNotification() async throws {
        let vm = NotificationViewModel()
        #expect(vm.notifications.isEmpty)
        #expect(vm.unreadCount == 0)

        let notification = FamilyNotification(
            title: "Test Alert",
            body: "Test Body",
            type: .systemAlert,
            priority: .high
        )

        vm.receive(notification)
        
        // Use a small delay for Combine publishers to update
        try await Task.sleep(nanoseconds: 10_000_000)
        
        #expect(vm.notifications.count == 1)
        #expect(vm.notifications.first?.title == "Test Alert")
        #expect(vm.unreadCount == 1)
    }

    @Test("Fungsi: markAsRead(id:) - Menandai Notifikasi sebagai Sudah Dibaca")
    func testMarkAsRead() async throws {
        let vm = NotificationViewModel()
        let notification = FamilyNotification(
            title: "Test Alert",
            body: "Test Body",
            type: .systemAlert,
            priority: .high
        )
        vm.receive(notification)
        try await Task.sleep(nanoseconds: 10_000_000)
        #expect(vm.unreadCount == 1)

        vm.markAsRead(id: notification.id)
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.notifications.first?.isRead == true)
        #expect(vm.unreadCount == 0)
    }

    @Test("Fungsi: markAllAsRead() - Menandai Semua sebagai Sudah Dibaca")
    func testMarkAllAsRead() async throws {
        let vm = NotificationViewModel()
        vm.receive(FamilyNotification(title: "Alert 1", body: "1", type: .systemAlert, priority: .low))
        vm.receive(FamilyNotification(title: "Alert 2", body: "2", type: .systemAlert, priority: .low))
        try await Task.sleep(nanoseconds: 10_000_000)
        
        #expect(vm.unreadCount == 2)

        vm.markAllAsRead()
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.unreadCount == 0)
        #expect(vm.notifications.allSatisfy { $0.isRead })
    }

    @Test("Fungsi: remove(id:) dan clearAll()")
    func testRemoveAndClearAll() async throws {
        let vm = NotificationViewModel()
        let notif1 = FamilyNotification(title: "1", body: "1", type: .systemAlert, priority: .low)
        let notif2 = FamilyNotification(title: "2", body: "2", type: .systemAlert, priority: .low)
        
        vm.receive(notif1)
        vm.receive(notif2)
        try await Task.sleep(nanoseconds: 10_000_000)
        #expect(vm.notifications.count == 2)

        vm.remove(id: notif1.id)
        try await Task.sleep(nanoseconds: 10_000_000)
        #expect(vm.notifications.count == 1)
        #expect(vm.notifications.first?.id == notif2.id)

        vm.clearAll()
        try await Task.sleep(nanoseconds: 10_000_000)
        #expect(vm.notifications.isEmpty)
        #expect(vm.unreadCount == 0)
    }

    @Test("Fungsi: notifications(ofType:) - Memfilter Tipe Notifikasi")
    func testNotificationsOfType() {
        let vm = NotificationViewModel()
        let sysNotif = FamilyNotification(title: "Sys", body: "1", type: .systemAlert, priority: .low)
        let prepNotif = FamilyNotification(title: "Prep", body: "2", type: .prepGuide, priority: .low)
        
        vm.receive(sysNotif)
        vm.receive(prepNotif)

        let sysList = vm.notifications(ofType: .systemAlert)
        let prepList = vm.notifications(ofType: .prepGuide)
        
        #expect(sysList.count == 1)
        #expect(sysList.first?.id == sysNotif.id)
        #expect(prepList.count == 1)
        #expect(prepList.first?.id == prepNotif.id)
    }

    @Test("Fungsi: simulatePrepGuideNotification(for:)")
    func testSimulatePrepGuideNotification() async throws {
        let vm = NotificationViewModel()
        vm.simulatePrepGuideNotification(for: "Flood")
        try await Task.sleep(nanoseconds: 10_000_000)
        
        #expect(vm.notifications.count == 1)
        #expect(vm.notifications.first?.title == "Flood Warning")
        #expect(vm.notifications.first?.type == .prepGuide)
        #expect(vm.unreadCount == 1)
    }
}
