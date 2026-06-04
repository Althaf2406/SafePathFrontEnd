import Foundation
import Testing
import CoreLocation
@testable import SafePath

@Suite("Location Service Tests")
struct LocationServiceTests {
    
    @Test("Fungsi: permissionDeniedState() - Skenario Ditolak")
    func testPermissionDeniedState() {
        let mockService = MockLocationService()
        // simulate deny
        mockService.authorizationStatus = .denied
        mockService.isAuthorized = false
        
        #expect(mockService.isAuthorized == false)
        #expect(mockService.authorizationStatus == .denied)
    }
    
    @Test("Fungsi: requestPermission() - Skenario Diijinkan")
    func testPermissionGrantedState() {
        let mockService = MockLocationService()
        
        mockService.requestPermission()
        
        #expect(mockService.requestPermissionCalled == true)
        #expect(mockService.isAuthorized == true)
        #expect(mockService.authorizationStatus == .authorizedWhenInUse)
    }
    
    @Test("Fungsi: startUpdating() - Skenario Berjalan")
    func testStartUpdatingLocation() {
        let mockService = MockLocationService()
        
        mockService.startUpdating()
        
        #expect(mockService.startUpdatingCalled == true)
    }
    
    @Test("Fungsi: stopUpdating() - Skenario Berhenti")
    func testStopUpdatingLocation() {
        let mockService = MockLocationService()
        
        mockService.stopUpdating()
        
        #expect(mockService.stopUpdatingCalled == true)
    }
}
