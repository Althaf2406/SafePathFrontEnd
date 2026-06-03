import Foundation
import WatchConnectivity
import Combine

/// Manages connectivity on the iOS side.
class IOSConnectivityManager: NSObject, ObservableObject, WCSessionDelegate {
    
    static let shared = IOSConnectivityManager()
    
    override private init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func sendToWatch(payload: [String: Any]) {
        guard WCSession.isSupported(), WCSession.default.activationState == .activated else { return }
        
        do {
            try WCSession.default.updateApplicationContext(payload)
        } catch {
            print("Error updating application context: \(error.localizedDescription)")
        }
        
        // Also send immediate message if watch is reachable
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(payload, replyHandler: nil) { error in
                print("Error sending message to watch: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - WCSessionDelegate
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed on iOS with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated on iOS with state: \(activationState.rawValue)")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Handle inactive
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Handle deactivate
        session.activate()
    }
    #endif
}
