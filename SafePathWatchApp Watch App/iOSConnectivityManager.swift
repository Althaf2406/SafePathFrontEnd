import Foundation
import WatchConnectivity
import Combine

class iOSConnectivityManager: NSObject, WCSessionDelegate, ObservableObject {
    var session: WCSession
    
    @Published var latestAlert: String = ""
    
    init(session: WCSession = .default) {
        self.session = session
        super.init()
        session.delegate = self
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func sendActionToiOS(action: String, data: [String: Any]? = nil) {
        if session.isReachable {
            var payload: [String: Any] = ["action": action]
            if let data = data {
                payload["data"] = data
            }
            session.sendMessage(payload, replyHandler: nil) { error in
                print("Error sending message: \(error.localizedDescription)")
            }
        } else {
            print("Session is not reachable!")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let alert = message["alert"] as? String {
                self.latestAlert = alert
            }
        }
    }
}
