////
////  ActiveFamilyDashboardView.swift
////  SafePath
////
////  Created by SafePath on 2026.
////
//
//import SwiftUI
//
//struct ActiveFamilyDashboardView: View {
//    @EnvironmentObject var userVM: UserManagementViewModel
//    @StateObject private var familyVM = FamilySafetyViewModel()
//    
//    @State private var showLeaveConfirm = false
//    
//    // Data dinamis dari familyVM
//    private var familyName: String {
//        familyVM.familyGroup?.name ?? userVM.currentUser?.name.components(separatedBy: " ").first.map { "\($0) Family" } ?? "My Family"
//    }
//    private var connectedMembers: Int {
//        familyVM.members.isEmpty ? 0 : familyVM.members.count
//    }
//    private var inviteCode: String {
//        familyVM.familyGroup?.inviteCode ?? "-"
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            // MARK: - Custom Navigation Bar
//            customTopBar
//            
//            ScrollView(showsIndicators: false) {
//                VStack(spacing: 24) {
//                    
//                    // MARK: - Family Header & Invite Code
//                    VStack(spacing: 16) {
//                        VStack(spacing: 4) {
//                            Text(familyName)
//                                .font(.system(size: 28, weight: .bold, design: .rounded))
//                                .foregroundColor(SafePathColors.textPrimary)
//                            
//                            Text("\(connectedMembers) Members Connected")
//                                .font(.system(size: 15, weight: .medium))
//                                .foregroundColor(SafePathColors.textSecondary)
//                        }
//                        
//                        // Invite Code Box
//                        HStack {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("Family Invite Code")
//                                    .font(.caption)
//                                    .foregroundColor(SafePathColors.textSecondary)
//                                Text(inviteCode)
//                                    .font(.system(size: 18, weight: .bold, design: .monospaced))
//                                    .foregroundColor(SafePathColors.primaryBlue)
//                            }
//                            Spacer()
//                            Button(action: {
//                                // Copy action here
//                            }) {
//                                Image(systemName: "doc.on.doc")
//                                    .foregroundColor(SafePathColors.primaryBlue)
//                                    .padding(10)
//                                    .background(SafePathColors.primaryBlue.opacity(0.1))
//                                    .clipShape(Circle())
//                            }
//                        }
//                        .padding()
//                        .background(Color.white)
//                        .cornerRadius(16)
//                        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 4)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                    
//                    // MARK: - Member Status List
//                    VStack(alignment: .leading, spacing: 16) {
//                        Text("Member Status")
//                            .font(.system(size: 20, weight: .bold, design: .rounded))
//                            .foregroundColor(SafePathColors.textPrimary)
//                            .padding(.horizontal, 20)
//                        
//                        if familyVM.isLoading {
//                            ProgressView("Loading members...")
//                                .padding()
//                        } else if familyVM.members.isEmpty {
//                            Text("No members yet.")
//                                .font(.system(size: 14))
//                                .foregroundColor(SafePathColors.textSecondary)
//                                .padding(.horizontal, 20)
//                        } else {
//                            VStack(spacing: 12) {
//                                ForEach(familyVM.members) { member in
//                                    HStack(spacing: 16) {
//                                        // Profile Avatar
//                                        Circle()
//                                            .fill(SafePathColors.primaryBlue.opacity(0.1))
//                                            .frame(width: 46, height: 46)
//                                            .overlay(
//                                                Text(String(member.name.prefix(1)))
//                                                    .font(.system(size: 20, weight: .bold))
//                                                    .foregroundColor(SafePathColors.primaryBlue)
//                                            )
//                                        
//                                        VStack(alignment: .leading, spacing: 4) {
//                                            Text(member.name)
//                                                .font(.system(size: 16, weight: .bold))
//                                                .foregroundColor(SafePathColors.textPrimary)
//                                            
//                                            HStack(spacing: 6) {
//                                                Circle()
//                                                    .fill(member.isInEmergency ? SafePathColors.dangerRed : (member.status == .unknown ? Color.gray.opacity(0.5) : SafePathColors.safeGreen))
//                                                    .frame(width: 8, height: 8)
//                                                
//                                                Text(member.status == .safe ? "Safe" : member.status == .needHelp ? "Need Help" : member.status == .sos ? "SOS" : member.status == .evacuating ? "Evacuating" : "Offline")
//                                                    .font(.system(size: 13, weight: .medium))
//                                                    .foregroundColor(member.isInEmergency ? SafePathColors.dangerRed : (member.status == .unknown ? Color.gray.opacity(0.5) : SafePathColors.safeGreen))
//                                            }
//                                        }
//                                        
//                                        Spacer()
//                                        
//                                        // Last Updated
//                                        Text(member.lastUpdatedDescription)
//                                            .font(.system(size: 12, weight: .medium))
//                                            .foregroundColor(SafePathColors.textSecondary)
//                                    }
//                                    .padding()
//                                    .background(Color.white)
//                                    .cornerRadius(16)
//                                    .shadow(color: Color.black.opacity(0.04), radius: 5, y: 2)
//                                }
//                            }
//                            .padding(.horizontal, 20)
//                        }
//                    }
//                    
//                    // MARK: - Box Buttons for Navigation
//                    VStack(spacing: 16) {
//                        
//                        // NEW: Giant SOS Button
//                        NavigationLink(destination: EmergencyStatusView()) {
//                            HStack {
//                                Spacer()
//                                VStack(spacing: 8) {
//                                    Image(systemName: "exclamationmark.triangle.fill")
//                                        .font(.system(size: 44))
//                                    Text("EMERGENCY SOS")
//                                        .font(.system(size: 22, weight: .black, design: .rounded))
//                                        .tracking(1.5)
//                                }
//                                .foregroundColor(.white)
//                                Spacer()
//                            }
//                            .padding(.vertical, 28)
//                            .background(
//                                LinearGradient(colors: [SafePathColors.dangerRed, Color.red.opacity(0.8)], startPoint: .top, endPoint: .bottom)
//                            )
//                            .cornerRadius(24)
//                            .shadow(color: SafePathColors.dangerRed.opacity(0.4), radius: 12, y: 8)
//                        }
//                        
//                        // Secondary Grid Actions
//                        HStack(spacing: 16) {
//                            NavigationLink(destination: LiveLocationFamilyView()) {
//                                VStack(alignment: .leading, spacing: 12) {
//                                    Image(systemName: "map.fill")
//                                        .font(.system(size: 28))
//                                        .foregroundColor(.white)
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("Live Map")
//                                            .font(.system(size: 16, weight: .bold, design: .rounded))
//                                            .foregroundColor(.white)
//                                        Text("Track Family")
//                                            .font(.system(size: 12, weight: .medium))
//                                            .foregroundColor(.white.opacity(0.8))
//                                    }
//                                }
//                                .padding(16)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(SafePathColors.primaryBlue)
//                                .cornerRadius(20)
//                                .shadow(color: SafePathColors.primaryBlue.opacity(0.3), radius: 8, y: 4)
//                            }
//                            
//                            NavigationLink(destination: FamilyNotificationsView()) {
//                                VStack(alignment: .leading, spacing: 12) {
//                                    Image(systemName: "bell.badge.fill")
//                                        .font(.system(size: 28))
//                                        .foregroundColor(SafePathColors.primaryBlue)
//                                    VStack(alignment: .leading, spacing: 4) {
//                                        Text("Alerts")
//                                            .font(.system(size: 16, weight: .bold, design: .rounded))
//                                            .foregroundColor(SafePathColors.textPrimary)
//                                        Text("History")
//                                            .font(.system(size: 12, weight: .medium))
//                                            .foregroundColor(SafePathColors.textSecondary)
//                                    }
//                                }
//                                .padding(16)
//                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .background(Color.white)
//                                .cornerRadius(20)
//                                .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
//                            }
//                        }
//                        
//                        // NEW: Leave Family Button
//                        Button(action: { showLeaveConfirm = true }) {
//                            HStack(spacing: 8) {
//                                Image(systemName: "rectangle.portrait.and.arrow.right")
//                                    .font(.system(size: 16, weight: .semibold))
//                                Text("Leave Family Group")
//                                    .font(.system(size: 16, weight: .bold, design: .rounded))
//                            }
//                            .foregroundColor(SafePathColors.dangerRed)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 16)
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(SafePathColors.dangerRed.opacity(0.3), lineWidth: 1)
//                            )
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 30)
//                }
//            }
//        }
//        .background(SafePathColors.backgroundLight.ignoresSafeArea())
//        .navigationBarHidden(true)
//        .onAppear {
//            if let groupID = userVM.currentUser?.familyGroupIDs.first {
//                Task {
//                    await familyVM.fetchGroup(groupID: groupID)
//                }
//            }
//        }
//        .confirmationDialog("Leave Family Group?", isPresented: $showLeaveConfirm, titleVisibility: .visible) {
//            Button("Leave Group", role: .destructive) {
//                Task {
//                    if let groupID = userVM.currentUser?.familyGroupIDs.first,
//                       let memberID = userVM.currentUser?.id {
//                        await familyVM.removeMember(groupID: groupID, memberID: memberID)
//                        // In real app, we would update user's group IDs and redirect
//                        // For UI demo, we can just print or handle state
//                    }
//                }
//            }
//            Button("Cancel", role: .cancel) {}
//        } message: {
//            Text("You will lose access to family location and alerts.")
//        }
//    }
//    
//    // MARK: - Top Bar
//    private var customTopBar: some View {
//        VStack(spacing: 0) {
//            HStack {
//                HStack(spacing: 8) {
//                    Image(systemName: "shield.lefthalf.filled")
//                        .foregroundColor(SafePathColors.primaryBlue)
//                        .font(.system(size: 24, weight: .bold))
//                    Text("SafePath")
//                        .font(.system(size: 24, weight: .bold, design: .rounded))
//                        .foregroundColor(SafePathColors.primaryBlue)
//                }
//                
//                Spacer()
//                
//                HStack(spacing: 16) {
//                    NavigationLink(destination: FamilyNotificationsView()) {
//                        ZStack(alignment: .topTrailing) {
//                            Image(systemName: "bell.fill")
//                                .font(.system(size: 22))
//                                .foregroundColor(SafePathColors.primaryBlue)
//                            
//                            Circle()
//                                .fill(SafePathColors.dangerRed)
//                                .frame(width: 10, height: 10)
//                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
//                        }
//                    }
//                    
//                    NavigationLink(destination: ProfilePageView()) {
//                        Image(systemName: "person.crop.circle.fill")
//                            .resizable()
//                            .frame(width: 34, height: 34)
//                            .foregroundColor(SafePathColors.textSecondary.opacity(0.4))
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
//                    }
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 14)
//            
//            Divider()
//        }
//        .background(Color.white)
//    }
//}
//
//#Preview {
//    ActiveFamilyDashboardView()
//}
//
////ttestst
