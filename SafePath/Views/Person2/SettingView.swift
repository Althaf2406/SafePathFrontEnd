//
//  SettingView.swift
//  SafePath
//
//  Created by SafePath on 2026.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserManagementViewModel

    // MARK: - Toggle States
    @State private var notificationsOn = true
    @State private var locationFamilyOnly = true
    @State private var offlineDataEnabled = true
    @State private var familyPrivacyOn = true
    @State private var darkModeOn = false
    @State private var accessibilityOn = false

    @State private var showSignOutConfirm = false
    @State private var showSavedToast = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {

                    // MARK: - Preferences Section
                    settingSection(label: "PREFERENCES") {
                        // Notification Settings
                        NavigationLink(destination: NotificationSettingsView()) {
                            settingRow(
                                icon: "bell.badge.fill",
                                iconBg: SafePathColors.dangerRed.opacity(0.12),
                                iconColor: SafePathColors.dangerRed,
                                title: "Notification Settings",
                                subtitle: notificationsOn ? "All On" : "Off"
                            )
                        }

                        Divider().padding(.leading, 60)

                        // Location Sharing
                        NavigationLink(destination: LocationSharingSettingsView()) {
                            settingRow(
                                icon: "location.fill",
                                iconBg: SafePathColors.primaryBlue.opacity(0.12),
                                iconColor: SafePathColors.primaryBlue,
                                title: "Location Sharing",
                                subtitle: "Family Only"
                            )
                        }

                        Divider().padding(.leading, 60)

                        // Offline Data
                        settingRow(
                            icon: "arrow.down.circle.fill",
                            iconBg: SafePathColors.safeGreen.opacity(0.12),
                            iconColor: SafePathColors.safeGreen,
                            title: "Offline Data",
                            subtitle: "320 MB"
                        )
                    }

                    // MARK: - Privacy & Access Section
                    settingSection(label: "PRIVACY & ACCESS") {
                        settingToggleRow(
                            icon: "person.2.fill",
                            iconBg: SafePathColors.primaryBlue.opacity(0.12),
                            iconColor: SafePathColors.primaryBlue,
                            title: "Family Privacy",
                            isOn: $familyPrivacyOn
                        )

                        Divider().padding(.leading, 60)

                        settingToggleRow(
                            icon: "moon.fill",
                            iconBg: Color.indigo.opacity(0.12),
                            iconColor: Color.indigo,
                            title: "Dark Mode",
                            isOn: $darkModeOn
                        )

                        Divider().padding(.leading, 60)

                        settingToggleRow(
                            icon: "figure.walk.circle.fill",
                            iconBg: SafePathColors.warningOrange.opacity(0.12),
                            iconColor: SafePathColors.warningOrange,
                            title: "Accessibility",
                            isOn: $accessibilityOn
                        )
                    }

                    // MARK: - System Section
                    settingSection(label: "SYSTEM") {
                        settingRow(
                            icon: "globe",
                            iconBg: Color.teal.opacity(0.12),
                            iconColor: Color.teal,
                            title: "Language",
                            subtitle: "English (US)"
                        )

                        Divider().padding(.leading, 60)

                        HStack {
                            settingRowIcon(
                                icon: "arrow.triangle.2.circlepath",
                                iconBg: SafePathColors.safeGreen.opacity(0.12),
                                iconColor: SafePathColors.safeGreen
                            )
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Sync Status")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(SafePathColors.textPrimary)
                                Text("Up to date")
                                    .font(.system(size: 13))
                                    .foregroundColor(SafePathColors.safeGreen)
                            }
                            Spacer()
                            Circle()
                                .fill(SafePathColors.safeGreen)
                                .frame(width: 8, height: 8)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                    }

                    // MARK: - Sign Out Button
                    Button(action: { showSignOutConfirm = true }) {
                        HStack(spacing: 10) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 16, weight: .semibold))
                            Text("Sign Out")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                        }
                        .foregroundColor(SafePathColors.dangerRed)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(SafePathColors.dangerRed.opacity(0.5), lineWidth: 1.5)
                        )
                        .shadow(color: Color.black.opacity(0.03), radius: 4, y: 2)
                    }
                    .padding(.horizontal, 16)

                    // MARK: - Version Footer
                    Text("SafePath v2.4.1 (1048)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(SafePathColors.textSecondary.opacity(0.6))
                        .padding(.bottom, 32)
                }
                .padding(.top, 12)
            }
            .background(SafePathColors.backgroundLight.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(SafePathColors.primaryBlue)
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(SafePathColors.textPrimary)
                }
            }
            .confirmationDialog("Sign out of SafePath?", isPresented: $showSignOutConfirm, titleVisibility: .visible) {
                Button("Sign Out", role: .destructive) {
                    Task {
                        await userVM.logout()
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .overlay(
                Group {
                    if showSavedToast { toastOverlay }
                }
            )
        }
    }

    // MARK: - Section Builder
    private func settingSection<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(SafePathColors.textSecondary)
                .tracking(0.8)
                .padding(.leading, 20)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 3)
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Row Helpers
    private func settingRow(icon: String, iconBg: Color, iconColor: Color, title: String, subtitle: String? = nil) -> some View {
        HStack {
            settingRowIcon(icon: icon, iconBg: iconBg, iconColor: iconColor)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(SafePathColors.textPrimary)
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 13))
                        .foregroundColor(SafePathColors.textSecondary)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(SafePathColors.textSecondary.opacity(0.4))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func settingToggleRow(icon: String, iconBg: Color, iconColor: Color, title: String, isOn: Binding<Bool>) -> some View {
        HStack {
            settingRowIcon(icon: icon, iconBg: iconBg, iconColor: iconColor)
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(SafePathColors.textPrimary)
            Spacer()
            Toggle("", isOn: isOn)
                .tint(SafePathColors.primaryBlue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func settingRowIcon(icon: String, iconBg: Color, iconColor: Color) -> some View {
        Image(systemName: icon)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(iconColor)
            .frame(width: 32, height: 32)
            .background(iconBg)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(.trailing, 12)
    }

    // MARK: - Toast
    private var toastOverlay: some View {
        VStack {
            Spacer()
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(SafePathColors.safeGreen)
                Text("Settings saved")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(red: 0.1, green: 0.15, blue: 0.2))
            .cornerRadius(30)
            .shadow(color: Color.black.opacity(0.2), radius: 10, y: 5)
            .padding(.bottom, 40)
        }
    }
}

// MARK: - Placeholder Sub-pages (linked from Settings)

struct NotificationSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var disasterAlerts = true
    @State private var familyStatus = true
    @State private var sosAlerts = true
    @State private var prepReminders = false
    @State private var selectedThreshold = 1
    @State private var liveMonitoring = true
    @State private var showSaved = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Notification Settings")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(SafePathColors.textPrimary)
                    Text("Configure how SafePath reaches you during emergencies and routine preparedness.")
                        .font(.system(size: 14))
                        .foregroundColor(SafePathColors.textSecondary)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)

                // Alert Types
                VStack(spacing: 0) {
                    toggleRow(icon: "exclamationmark.triangle.fill", iconColor: SafePathColors.dangerRed, title: "Disaster Alerts", sub: "FEMA, NOAA, and local reports", isOn: $disasterAlerts)
                    Divider().padding(.leading, 60)
                    toggleRow(icon: "person.2.fill", iconColor: SafePathColors.primaryBlue, title: "Family Status", sub: "Check-ins and safety updates", isOn: $familyStatus)
                    Divider().padding(.leading, 60)
                    toggleRow(icon: "sos", iconColor: SafePathColors.dangerRed, title: "SOS Alerts", sub: "Critical life-safety broadcasts", isOn: $sosAlerts)
                    Divider().padding(.leading, 60)
                    toggleRow(icon: "checklist", iconColor: SafePathColors.safeGreen, title: "Preparedness Reminders", sub: "Kit refreshes and drills", isOn: $prepReminders)
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
                .padding(.horizontal, 16)

                // Severity Threshold
                VStack(alignment: .leading, spacing: 10) {
                    Text("ALERT SEVERITY THRESHOLD")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(SafePathColors.textSecondary)
                        .tracking(0.8)
                        .padding(.leading, 4)

                    VStack(spacing: 0) {
                        thresholdRow(title: "Critical", sub: "Only life-threatening emergencies", idx: 0)
                        Divider().padding(.leading, 16)
                        thresholdRow(title: "Medium+", sub: "Major incidents and weather warnings", idx: 1)
                        Divider().padding(.leading, 16)
                        thresholdRow(title: "All", sub: "Every alert, reminder, and update", idx: 2)
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
                }
                .padding(.horizontal, 16)

                // Live Monitoring
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LIVE MONITORING")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(SafePathColors.textSecondary)
                                .tracking(0.8)
                            Text("Your 24/7 Safety Net")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(SafePathColors.textPrimary)
                        }
                        Spacer()
                        Toggle("", isOn: $liveMonitoring)
                            .tint(SafePathColors.primaryBlue)
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
                .padding(.horizontal, 16)

                Button(action: { withAnimation { showSaved = true }; DispatchQueue.main.asyncAfter(deadline: .now()+2){ withAnimation { showSaved = false } } }) {
                    Text("Save Preferences")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(SafePathColors.primaryBlue)
                        .cornerRadius(14)
                        .shadow(color: SafePathColors.primaryBlue.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

                Text("CHANGES WILL BE SYNCHRONIZED ACROSS ALL FAMILY DEVICES")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(SafePathColors.textSecondary.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .tracking(0.4)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationTitle("Notification Settings")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(Group {
            if showSaved {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(SafePathColors.safeGreen)
                        Text("Settings saved successfully").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.white)
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                    .background(Color(red: 0.1, green: 0.15, blue: 0.2)).cornerRadius(30)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    .padding(.bottom, 40)
                }
            }
        })
    }

    private func toggleRow(icon: String, iconColor: Color, title: String, sub: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .semibold)).foregroundColor(SafePathColors.textPrimary)
                Text(sub).font(.system(size: 12)).foregroundColor(SafePathColors.textSecondary)
            }
            Spacer()
            Toggle("", isOn: isOn).tint(SafePathColors.primaryBlue)
        }
        .padding(.horizontal, 16).padding(.vertical, 12)
    }

    private func thresholdRow(title: String, sub: String, idx: Int) -> some View {
        Button(action: { selectedThreshold = idx }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.system(size: 15, weight: .semibold)).foregroundColor(SafePathColors.textPrimary)
                    Text(sub).font(.system(size: 12)).foregroundColor(SafePathColors.textSecondary)
                }
                Spacer()
                Image(systemName: selectedThreshold == idx ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedThreshold == idx ? SafePathColors.primaryBlue : SafePathColors.textSecondary.opacity(0.3))
                    .font(.system(size: 20))
            }
            .padding(.horizontal, 16).padding(.vertical, 14)
        }
    }
}

struct LocationSharingSettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var realtimeShare = true
    @State private var emergencyOnly = false
    @State private var shareOffline = true
    @State private var showSaved = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // GPS Status Banner
                HStack(spacing: 12) {
                    Image(systemName: "location.fill")
                        .foregroundColor(SafePathColors.safeGreen)
                        .font(.system(size: 20))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("GPS Active: Precise")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(SafePathColors.textPrimary)
                    }
                    Spacer()
                    Circle()
                        .fill(SafePathColors.safeGreen)
                        .frame(width: 10, height: 10)
                }
                .padding()
                .background(SafePathColors.safeGreen.opacity(0.08))
                .cornerRadius(14)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(SafePathColors.safeGreen.opacity(0.2), lineWidth: 1))
                .padding(.horizontal, 16)
                .padding(.top, 12)

                // Privacy Note
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(SafePathColors.primaryBlue)
                        .font(.system(size: 18))
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Privacy Commitment")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(SafePathColors.textPrimary)
                        Text("Only authorized family members can view your location. Your data is encrypted and never shared with third parties.")
                            .font(.system(size: 13))
                            .foregroundColor(SafePathColors.textSecondary)
                            .lineSpacing(2)
                    }
                }
                .padding()
                .background(SafePathColors.primaryBlue.opacity(0.05))
                .cornerRadius(14)
                .padding(.horizontal, 16)

                // Sharing Preferences
                VStack(alignment: .leading, spacing: 8) {
                    Text("SHARING PREFERENCES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(SafePathColors.textSecondary)
                        .tracking(0.8)
                        .padding(.leading, 4)

                    VStack(spacing: 0) {
                        sharingRow(
                            icon: "location.fill",
                            iconColor: SafePathColors.primaryBlue,
                            title: "Share real-time location",
                            sub: "Continuous updates for your circle",
                            isOn: $realtimeShare
                        )
                        Divider().padding(.leading, 60)
                        sharingRow(
                            icon: "sos",
                            iconColor: SafePathColors.dangerRed,
                            title: "Share only during emergency",
                            sub: "Activates only when SOS is triggered",
                            isOn: $emergencyOnly
                        )
                        Divider().padding(.leading, 60)
                        sharingRow(
                            icon: "wifi.slash",
                            iconColor: SafePathColors.textSecondary,
                            title: "Share last known location when offline",
                            sub: "Preserves battery and works without signal",
                            isOn: $shareOffline
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
                }
                .padding(.horizontal, 16)

                Button(action: { withAnimation { showSaved = true }; DispatchQueue.main.asyncAfter(deadline: .now()+2){ withAnimation { showSaved = false } } }) {
                    Text("Save Settings")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(SafePathColors.primaryBlue)
                        .cornerRadius(14)
                        .shadow(color: SafePathColors.primaryBlue.opacity(0.3), radius: 8, y: 4)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationTitle("Location Sharing")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(Group {
            if showSaved {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(SafePathColors.safeGreen)
                        Text("Settings saved").font(.system(size: 14, weight: .bold, design: .rounded)).foregroundColor(.white)
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                    .background(Color(red: 0.1, green: 0.15, blue: 0.2)).cornerRadius(30)
                    .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
                    .padding(.bottom, 40)
                }
            }
        })
    }

    private func sharingRow(icon: String, iconColor: Color, title: String, sub: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.trailing, 12)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 14, weight: .semibold)).foregroundColor(SafePathColors.textPrimary)
                Text(sub).font(.system(size: 12)).foregroundColor(SafePathColors.textSecondary)
            }
            Spacer()
            Toggle("", isOn: isOn).tint(SafePathColors.primaryBlue)
        }
        .padding(.horizontal, 16).padding(.vertical, 14)
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
