import SwiftUI

struct PreparednessPadView: View {
    @EnvironmentObject var viewModel: PreparednessViewModel
    @EnvironmentObject var userVM: UserManagementViewModel

    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Be ready before disaster happens.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        overallReadinessCard
                        localRiskProfileCard
                        emergencyKitCard
                        quickActionsSection
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 24)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Preparedness")
            .task {
                let lat = userVM.currentUser?.lastLatitude ?? -7.2504
                let lng = userVM.currentUser?.lastLongitude ?? 112.7688
                await viewModel.load(lat: lat, lng: lng, userId: userVM.currentUser?.id)
            }
        }
    }

    // MARK: - Overall Readiness
    private var overallReadinessCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading) {
                    Text("OVERALL READINESS")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)

                    Text("\(Int(viewModel.overallReadiness * 100))%")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.blue)
                }
                Spacer()
                Image(systemName: "shield.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.blue.opacity(0.1))
                    .clipShape(Circle())
            }

            ProgressView(value: viewModel.overallReadiness)
                .tint(.blue)
                .scaleEffect(x: 1, y: 1.5, anchor: .center)

            Text("\(viewModel.completedItemsCount) of \(viewModel.totalItemsCount) items prepared")
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    // MARK: - Local Risk Profile
    private var localRiskProfileCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "target")
                Text("Local Risk Profile")
                    .font(.title3.bold())
            }
            .foregroundColor(.primary)

            if viewModel.riskProfiles.isEmpty {
                Text("Loading risk profiles...")
                    .font(.body)
                    .foregroundColor(.secondary)
            } else {
                ForEach(viewModel.riskProfiles) { risk in
                    HStack {
                        Image(systemName: risk.iconName)
                            .foregroundColor(risk.level.color)
                            .frame(width: 40, height: 40)
                            .background(risk.level.color.opacity(0.1))
                            .clipShape(Circle())

                        Text(risk.type)
                            .font(.body)
                            .fontWeight(.medium)

                        Spacer()

                        Text(risk.level.rawValue)
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(risk.level.color)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(risk.level.color.opacity(0.05))
                    .cornerRadius(12)
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    // MARK: - Emergency Kit
    private var emergencyKitCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Image(systemName: "cross.case")
                Text("Emergency Kit")
                    .font(.title3.bold())
            }

            Text("Essential items for 72-hour survival.")
                .font(.body)
                .foregroundColor(.secondary)

            HStack(spacing: 32) {
                CircularProgressView(
                    progress: viewModel.overallReadiness,
                    text: "\(viewModel.completedItemsCount)/\(viewModel.totalItemsCount)"
                )
                .frame(width: 100, height: 100)

                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.emergencyKit.prefix(4)) { item in
                        HStack {
                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(item.isChecked ? .green : .secondary)
                            Text(item.name)
                                .foregroundColor(item.isChecked ? .secondary : .primary)
                                .strikethrough(item.isChecked)
                        }
                        .font(.body)
                    }
                    if viewModel.emergencyKit.count > 4 {
                        Text("+\(viewModel.emergencyKit.count - 4) more items")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                }
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    // MARK: - Quick Actions
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Quick Actions")
                .font(.title3.bold())

            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    QuickActionPadButton(
                        title: "Emergency Checklist",
                        icon: "checklist",
                        backgroundColor: Color.blue.opacity(0.15),
                        foregroundColor: .primary,
                        action: ChecklistPadView()
                    )

                    QuickActionPadButton(
                        title: "First Aid Guide",
                        icon: "bandage",
                        backgroundColor: Color.blue.opacity(0.15),
                        foregroundColor: .primary,
                        action: FirstAidGuidePadView()
                    )
                }

                QuickActionPadButton(
                    title: "Disaster Prep Guide",
                    icon: "book.fill",
                    backgroundColor: Color.blue.opacity(0.15),
                    foregroundColor: .primary,
                    action: DisasterPreparationGuidePadView()
                )
            }
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
}

// MARK: - Quick Action Button Pad Component
struct QuickActionPadButton<Destination: View>: View {
    let title: String
    let icon: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: Destination

    var body: some View {
        NavigationLink(destination: action) {
            VStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 32))

                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
        }
    }
}
