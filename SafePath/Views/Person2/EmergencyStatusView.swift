import SwiftUI

struct EmergencyStatusView: View {
    @EnvironmentObject var userVM: UserManagementViewModel // Menggunakan ViewModel asli kamu
    @State private var navigateToNotifications = false
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Top Bar
            customTopBar
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Family Identity Header
                    familyHeader
                        .padding(.top, 10)
                    
                    // MARK: - Member Status List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Member Status")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(SafePathColors.textSecondary)
                            .padding(.leading, 4)
                        
                        VStack(spacing: 12) {
                            // Mengambil nama user secara dinamis dari currentUser kamu jika tersedia
                            memberRow(name: userVM.currentUser?.name ?? "Muhammad Althaf", status: "Safe", battery: 96, color: SafePathColors.safeGreen, icon: "checkmark.shield.fill")
                            memberRow(name: "Nevandio", status: "Safe", battery: 82, color: SafePathColors.safeGreen, icon: "checkmark.shield.fill")
                            memberRow(name: "Dzaky", status: "Need Help", battery: 46, color: SafePathColors.dangerRed, icon: "exclamationmark.triangle.fill", isAlert: true)
                            memberRow(name: "Louie", status: "Offline", battery: 18, color: .gray, icon: "person.fill.viewfinder")
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: - Action Buttons
                    VStack(spacing: 14) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "map.fill")
                                Text("Family Map")
                            }
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(SafePathColors.primaryBlue)
                            .cornerRadius(12)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "person.badge.plus.fill")
                                Text("Add Family Member")
                            }
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(SafePathColors.primaryBlue)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(SafePathColors.primaryBlue.opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationBarHidden(true)
        // Direct routing ke halaman notifikasi menggunakan fitur native iOS 16+
        .navigationDestination(isPresented: $navigateToNotifications) {
            FamilyNotificationsView()
        }
    }
    
    // MARK: - Subviews
    
    private var customTopBar: some View {
        HStack {
            HStack(spacing: 12) {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(SafePathColors.primaryBlue)
                    .font(.system(size: 26))
                Text("Family Safety")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(SafePathColors.textPrimary)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                // Tombol Lonceng Notifikasi untuk berpindah ke halaman notifikasi
                Button(action: { navigateToNotifications = true }) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundColor(SafePathColors.primaryBlue)
                        
                        Circle()
                            .fill(SafePathColors.dangerRed)
                            .frame(width: 10, height: 10)
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                }
                
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 34, height: 34)
                    .foregroundColor(SafePathColors.textSecondary.opacity(0.4))
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.white)
    }
    
    private var familyHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Althaf Family")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(SafePathColors.textPrimary)
                Text("4 members connected")
                    .font(.system(size: 14))
                    .foregroundColor(SafePathColors.textSecondary)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Family Invite Code")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(SafePathColors.textSecondary)
                    Text("SAFE-2941")
                        .font(.system(size: 22, weight: .black, design: .monospaced))
                        .foregroundColor(SafePathColors.primaryBlue)
                }
                Spacer()
                Button(action: {}) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(SafePathColors.primaryBlue)
                        .padding(10)
                        .background(SafePathColors.primaryBlue.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(20)
            .background(SafePathColors.primaryBlue.opacity(0.05))
            .cornerRadius(16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(SafePathColors.primaryBlue.opacity(0.1), lineWidth: 1))
        }
        .padding(.horizontal, 20)
    }
    
    private func memberRow(name: String, status: String, battery: Int, color: Color, icon: String, isAlert: Bool = false) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 48, height: 48)
                Text(String(name.prefix(1)))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(SafePathColors.textPrimary)
                
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 10))
                    Text(status)
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(color)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: battery < 20 ? "battery.25" : "battery.100")
                    Text("\(battery)%")
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(battery < 20 ? SafePathColors.dangerRed : SafePathColors.textPrimary)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: isAlert ? SafePathColors.dangerRed.opacity(0.1) : Color.black.opacity(0.03), radius: 8, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isAlert ? SafePathColors.dangerRed.opacity(0.2) : Color.clear, lineWidth: 1)
        )
    }
}

#Preview{
    EmergencyStatusView()
}
