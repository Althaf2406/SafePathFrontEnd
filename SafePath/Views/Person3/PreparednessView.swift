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
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isChecked ? .green : .secondary)
                            Text(item.name)
                                .foregroundColor(item.isChecked ? .secondary : .primary)
                                .strikethrough(item.isChecked)
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
                    action: Text("Checklist Coming Soon")
                )
                
                QuickActionButton(
                    title: "First Aid Guide",
                    icon: "bandage", // SF Symbol yang lebih native untuk P3K
                    backgroundColor: Color.blue.opacity(0.15),
                    foregroundColor: .primary,
                    action: Text("First Aid Coming Soon")
                )
            }
            
            QuickActionButton(
                title: "Offline Resources",
                icon: "wifi.slash",
                backgroundColor: Color.blue.opacity(0.15),
                foregroundColor: .primary,
                action: Text("Offline Resources"),
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
            AnyView(action)
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

// MARK: - Missing Components

struct RiskBadge: View {
    let level: RiskLevel
    var body: some View {
        Text(level.rawValue)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(level.color.opacity(0.2))
            .foregroundColor(level.color)
            .cornerRadius(8)
    }
}

struct CircularProgressView: View {
    let progress: Double
    let text: String
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 6)
                .opacity(0.3)
                .foregroundColor(.blue)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 6, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(Angle(degrees: 270.0))
            
            Text(text)
                .font(.caption)
                .fontWeight(.bold)
        }
        .frame(width: 50, height: 50)
    }
}

extension View {
    func cardStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
}

// MARK: - Preview
struct PreparednessView_Previews: PreviewProvider {
    static var previews: some View {
        PreparednessView()
            .environmentObject(PreparednessViewModel())
    }
}
