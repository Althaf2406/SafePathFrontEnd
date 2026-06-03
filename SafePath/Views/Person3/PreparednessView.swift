//
//  PreparednessView.swift
//  SafePath
//
//  Created by Shatrya Christiano on 03/06/26.
//


//
//  PreparednessView.swift
//  SafePath
//
//  Created by Shatrya Christiano on 03/06/26.
//


//
//  PreparednessView.swift
//  SafePath
//
//  Created by Shatrya Christiano on 30/05/26.
//


import SwiftUI

struct PreparednessView: View {
    @EnvironmentObject var viewModel: PreparednessViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Subtitle (Karena NavigationTitle hanya teks besar)
                    Text("Be ready before disaster happens.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, -10)
                    
                    overallReadinessCard
                    localRiskProfileCard
                    emergencyKitCard
                    quickActionsSection
                }
                .padding()
            }
            .background(Color(UIColor.systemGroupedBackground)) // Warna background khas Apple
            .navigationTitle("Preparedness")
        }
    }
    
    // MARK: - Subviews
    
    private var overallReadinessCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    Text("OVERALL READINESS")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    HStack(alignment: .firstTextBaseline) {
                        Text("\(Int(viewModel.overallReadiness * 100))%")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.blue)
//                        Text("Fair")
//                            .font(.headline)
//                            .foregroundColor(.blue)
                    }
                }
                Spacer()
                Image(systemName: "shield.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }
            
            ProgressView(value: viewModel.overallReadiness)
                .tint(.blue)
            
//            Text("Complete your Emergency Kit to reach 80%")
//                .font(.caption)
//                .foregroundColor(.secondary)
        }
        .cardStyle()
    }
    
    private var localRiskProfileCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "target")
                Text("Local Risk Profile")
                    .font(.headline)
            }
            .foregroundColor(.primary)
            
            ForEach(viewModel.riskProfiles) { risk in
                HStack {
                    Image(systemName: risk.iconName)
                        .foregroundColor(risk.level.color)
                        .frame(width: 30, height: 30)
                        .background(risk.level.color.opacity(0.1))
                        .clipShape(Circle())
                    
                    Text(risk.type)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    RiskBadge(level: risk.level)
                }
                .padding()
                .background(risk.level.color.opacity(0.05))
                .cornerRadius(12)
            }
        }
        .cardStyle()
    }
    
    private var emergencyKitCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "cross.case")
                Text("Emergency Kit")
                    .font(.headline)
            }
            
            Text("Essential items for 72-hour survival.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 24) {
                CircularProgressView(
                    progress: viewModel.overallReadiness,
                    text: "\(viewModel.completedItemsCount)/\(viewModel.totalItemsCount)"
                )
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.emergencyKit) { item in
                        HStack {
                            Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isCompleted ? .green : .secondary)
                            Text(item.name)
                                .foregroundColor(item.isCompleted ? .secondary : .primary)
                                .strikethrough(item.isCompleted)
                        }
                        .font(.subheadline)                    }
                }
            }
        }
        .cardStyle()
    }
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .padding(.top, 8)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    title: "Emergency Checklist",
                    icon: "checklist",
                    backgroundColor: Color(red: 0.1, green: 0.2, blue: 0.5), // Dark Blue
                    foregroundColor: .white,
                    action: CustomizeChecklistView()
                )
                
                QuickActionButton(
                    title: "First Aid Guide",
                    icon: "bandage", // SF Symbol yang lebih native untuk P3K
                    backgroundColor: Color.blue.opacity(0.15),
                    foregroundColor: .primary,
                    action: FirstAidGuideView()
                )
            }
            
            QuickActionButton(
                title: "Offline Resources",
                icon: "wifi.slash",
                backgroundColor: Color.blue.opacity(0.15),
                foregroundColor: .primary,
                isFullWidth: true
            )
        }
    }
}

// MARK: - Quick Action Button Component
struct QuickActionButton: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: any View
    var isFullWidth: Bool = false
    
    var body: some View {
        NavigationLink {
            
        } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)

                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: isFullWidth ? 80 : 100)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
        }    }
}

// MARK: - Preview
struct PreparednessView_Previews: PreviewProvider {
    static var previews: some View {
        PreparednessView()
    }
}
