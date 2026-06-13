import Foundation
import Testing

@testable import SafePath

@Suite("OfflineMapViewModel Tests")
@MainActor
struct OfflineMapViewModelTests {

    @Test("Fungsi: Initialization - Nilai Awal Kosong")
    func testInitialState() {
        let vm = OfflineMapViewModel()
        #expect(vm.downloadedMaps.isEmpty)
        #expect(vm.isDownloading == false)
    }
}
