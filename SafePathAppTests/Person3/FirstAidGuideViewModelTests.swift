import Foundation
import Testing

@testable import SafePath

@Suite("FirstAidGuide ViewModel Tests")
@MainActor
struct FirstAidGuideViewModelTests {

    @Test("Fungsi: loadGuides() - Skenario Berhasil")
    func testLoadGuidesSuccess() async throws {
        let mockRepo = MockFirstAidRepository()
        mockRepo.guidesToReturn = [
            TestDataFactory.mockFirstAidGuide(title: "CPR"),
            TestDataFactory.mockFirstAidGuide(title: "Burns")
        ]

        let vm = FirstAidGuideViewModel(repository: mockRepo)
        
        // Give time for Combine publisher to sink on Main thread
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.guides.count == 2)
        #expect(vm.guides[0].title == "CPR")
    }

    @Test("Fungsi: loadGuides() - Skenario Gagal")
    func testLoadGuidesFailure() async throws {
        let mockRepo = MockFirstAidRepository()
        mockRepo.shouldThrowError = true

        let vm = FirstAidGuideViewModel(repository: mockRepo)
        
        try await Task.sleep(nanoseconds: 10_000_000)

        #expect(vm.guides.isEmpty)
    }

    @Test("Fungsi: filteredGuides - Pencarian Sesuai")
    func testSearchGuidesMatch() async throws {
        let mockRepo = MockFirstAidRepository()
        mockRepo.guidesToReturn = [
            TestDataFactory.mockFirstAidGuide(title: "CPR"),
            TestDataFactory.mockFirstAidGuide(title: "Burns")
        ]

        let vm = FirstAidGuideViewModel(repository: mockRepo)
        try await Task.sleep(nanoseconds: 10_000_000)

        vm.searchQuery = "Burn"

        #expect(vm.filteredGuides.count == 1)
        #expect(vm.filteredGuides.first?.title == "Burns")
    }

    @Test("Fungsi: filteredGuides - Pencarian Tidak Cocok")
    func testSearchGuidesNoMatch() async throws {
        let mockRepo = MockFirstAidRepository()
        mockRepo.guidesToReturn = [
            TestDataFactory.mockFirstAidGuide(title: "CPR")
        ]

        let vm = FirstAidGuideViewModel(repository: mockRepo)
        try await Task.sleep(nanoseconds: 10_000_000)

        vm.searchQuery = "Choking"

        #expect(vm.filteredGuides.isEmpty)
    }
}

//
