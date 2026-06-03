//
//  ActiveFamilyDashboardView.swift
//  SafePath
//
//  Created by SafePath on 2026.
//

import SwiftUI

struct ActiveFamilyDashboardView: View {
    
    // Mock Data for UI
    let familyName = "Jae's Family"
    let connectedMembers = 4
    let inviteCode = "JAE-9482-SAF"
    
    struct Member: Identifiable {
        let id = UUID()
        let name: String
        let status: Status
        let battery: Int
        
        enum Status {
            case safe, needHelp, offline
            
            var color: Color {
                switch self {
                case .safe: return SafePathColors.safeGreen
                case .needHelp: return SafePathColors.dangerRed
                case .offline: return Color.gray.opacity(0.5)
                }
            }
            
            var text: String {
                switch self {
                case .safe: return "Safe"
                case .needHelp: return "Need Help"
                case .offline: return "Offline"
                }
            }
        }
    }
    
    let members: [Member] = [
        Member(name: "Jae (You)", status: .safe, battery: 85),
        Member(name: "Mom", status: .safe, battery: 60),
        Member(name: "Dad", status: .offline, battery: 12),
        Member(name: "Sis", status: .needHelp, battery: 45)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: - Custom Navigation Bar
            customTopBar
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    
                    // MARK: - Family Header & Invite Code
                    VStack(spacing: 16) {
                        VStack(spacing: 4) {
                            Text(familyName)
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(SafePathColors.textPrimary)
                            
                            Text("\(connectedMembers) Members Connected")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(SafePathColors.textSecondary)
                        }
                        
                        // Invite Code Box
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Family Invite Code")
                                    .font(.caption)
                                    .foregroundColor(SafePathColors.textSecondary)
                                Text(inviteCode)
                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                                    .foregroundColor(SafePathColors.primaryBlue)
                            }
                            Spacer()
                            Button(action: {
                                // Copy action here
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .foregroundColor(SafePathColors.primaryBlue)
                                    .padding(10)
                                    .background(SafePathColors.primaryBlue.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // MARK: - Member Status List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Member Status")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(SafePathColors.textPrimary)
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 12) {
                            ForEach(members) { member in
                                HStack(spacing: 16) {
                                    // Profile Avatar Placeholder
                                    Circle()
                                        .fill(SafePathColors.primaryBlue.opacity(0.1))
                                        .frame(width: 46, height: 46)
                                        .overlay(
                                            Text(String(member.name.prefix(1)))
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(SafePathColors.primaryBlue)
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(member.name)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(SafePathColors.textPrimary)
                                        
                                        HStack(spacing: 6) {
                                            Circle()
                                                .fill(member.status.color)
                                                .frame(width: 8, height: 8)
                                            
                                            Text(member.status.text)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(member.status.color)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Battery Indicator
                                    HStack(spacing: 4) {
                                        Text("\(member.battery)%")
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(member.battery <= 20 ? SafePathColors.dangerRed : SafePathColors.textSecondary)
                                        
                                        Image(systemName: member.battery <= 20 ? "battery.25" : "battery.100")
                                            .foregroundColor(member.battery <= 20 ? SafePathColors.dangerRed : SafePathColors.textSecondary)
                                            .font(.system(size: 12))
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: Color.black.opacity(0.04), radius: 5, y: 2)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: - Box Buttons for Navigation
                    VStack(spacing: 16) {
                        NavigationLink(destination: LiveLocationFamilyView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Live Location")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(.white)
                                    Text("Track family members on the map")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                Spacer()
                                Image(systemName: "map.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(colors: [SafePathColors.primaryBlue, SafePathColors.primaryBlue.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                            .cornerRadius(20)
                            .shadow(color: SafePathColors.primaryBlue.opacity(0.3), radius: 8, y: 4)
                        }
                        
                        NavigationLink(destination: FamilyNotificationsView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Family Notifications")
                                        .font(.system(size: 18, weight: .bold, design: .rounded))
                                        .foregroundColor(SafePathColors.primaryBlue)
                                    Text("View emergency alerts and updates")
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(SafePathColors.textSecondary)
                                }
                                Spacer()
                                Image(systemName: "bell.badge.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(SafePathColors.primaryBlue.opacity(0.8))
                            }
                            .padding(20)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(SafePathColors.primaryBlue.opacity(0.1), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationBarHidden(true)
    }
    
    // MARK: - Top Bar
    private var customTopBar: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "shield.lefthalf.filled")
                        .foregroundColor(SafePathColors.primaryBlue)
                        .font(.system(size: 24, weight: .bold))
                    Text("SafePath")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(SafePathColors.primaryBlue)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(SafePathColors.textPrimary)
                    
                    NavigationLink(destination: ProfilePageView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 34, height: 34)
                            .foregroundColor(SafePathColors.textSecondary.opacity(0.4))
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
            
            Divider()
        }
        .background(Color.white)
    }
}

#Preview {
    ActiveFamilyDashboardView()
}
