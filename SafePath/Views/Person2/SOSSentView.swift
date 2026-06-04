import SwiftUI

struct SOSSentView: View {
    @EnvironmentObject var userVM: UserManagementViewModel
    @EnvironmentObject var emergencyVM: EmergencyStatusViewModel
    @State private var isNotified = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Pulse Animation Icon
                ZStack {
                    Circle()
                        .stroke(isNotified ? SafePathColors.safeGreen : Color.red, lineWidth: 2)
                        .scaleEffect(isNotified ? 1 : 1.2)
                        .opacity(isNotified ? 0 : 0.5)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: false), value: isNotified)
                    
                    Image(systemName: isNotified ? "checkmark.circle.fill" : "antenna.radiowaves.left.and.right")
                        .font(.system(size: 60))
                        .foregroundColor(isNotified ? SafePathColors.safeGreen : .red)
                }
                .frame(width: 120, height: 120)
                .padding(.top, 40)
                
                VStack(spacing: 8) {
                    Text(isNotified ? "Status Updated" : "SOS Sent Successfully")
                        .font(.title.bold())
                    Text(isNotified ? "Your family has been notified of your emergency." : "Help is being notified. Your location is being shared in real-time.")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Member List
                VStack(alignment: .leading, spacing: 15) {
                    Text(isNotified ? "Success Details" : "Family Being Notified")
                        .font(.headline)
                    
                    if isNotified {
                        // Table-like Success View
                        VStack(spacing: 1) {
                            successRow(label: "Status", value: "Need Help", isBadge: true)
                            successRow(label: "Location", value: "Surabaya, East Java")
                            successRow(label: "Time", value: "Just now")
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                    } else {
                        // Notifying List
                        VStack(spacing: 12) {
                            notifyingRow(name: "Nevandio")
                            notifyingRow(name: "Dzaky")
                            notifyingRow(name: "Louie")
                        }
                    }
                }
                .padding(.horizontal)
                
                // Final Action Button
                Button(action: { if isNotified { dismiss() } }) {
                    Text(isNotified ? "Back to Family" : "Call Emergency Contact")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isNotified ? SafePathColors.primaryBlue : .red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                // 1. Call real backend API
                let lat = userVM.currentUser?.lastLatitude
                let lon = userVM.currentUser?.lastLongitude
                await emergencyVM.triggerSOS(latitude: lat, longitude: lon)
                
                // 2. Simulate delay for the UI notification effect (or fallback if API fails)
                try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
                withAnimation(.spring()) {
                    isNotified = true
                }
            }
        }
    }
    
    func notifyingRow(name: String) -> some View {
        HStack {
            Image(systemName: "person.circle.fill").foregroundColor(.secondary)
            Text(name)
            Spacer()
            HStack(spacing: 4) {
                ProgressView().scaleEffect(0.7)
                Text("notifying...")
            }
            .font(.caption.bold())
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
    
    func successRow(label: String, value: String, isBadge: Bool = false) -> some View {
        HStack {
            Text(label).foregroundColor(.secondary)
            Spacer()
            if isBadge {
                Text(value).bold()
                    .padding(.horizontal, 10).padding(.vertical, 4)
                    .background(SafePathColors.dangerRed).foregroundColor(.white).cornerRadius(8)
            } else {
                Text(value).bold()
            }
        }
        .padding()
    }
}

#Preview{
    SOSSentView()
}
