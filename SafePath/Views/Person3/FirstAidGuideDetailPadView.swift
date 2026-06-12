import SwiftUI

struct FirstAidGuideDetailPadView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserManagementViewModel
    let guide: FirstAidGuide
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                
                // Header details
                HStack {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                        Text("OFFLINE AVAILABLE")
                            .font(.system(size: 14, weight: .bold))
                    }
                    .foregroundColor(SafePathColors.textPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                    
                    Spacer()
                }
                
                Text(guide.title)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundColor(SafePathColors.textPrimary)
                
                // Action Buttons
                HStack(spacing: 24) {
                    Button(action: {
                        let phone = userVM.currentUser?.phone ?? "911"
                        if let url = URL(string: "tel://\(phone)") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "staroflife.fill")
                            Text("Call Emergency Contact")
                        }
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(SafePathColors.dangerRed)
                        .cornerRadius(16)
                    }
                    
                    NavigationLink(destination: MainMapView()) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text("Find Shelter")
                        }
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(SafePathColors.primaryBlue)
                        .cornerRadius(16)
                    }
                }
                
                HStack(alignment: .top, spacing: 40) {
                    // Left Column: Instructions
                    VStack(alignment: .leading, spacing: 32) {
                        Text("Instructions")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(SafePathColors.textPrimary)
                            .padding(.top, 10)
                        
                        ForEach(Array(guide.detailedSteps.enumerated()), id: \.element.id) { index, step in
                            HStack(alignment: .top, spacing: 24) {
                                // Number circle
                                Text("\(index + 1)")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .frame(width: 48, height: 48)
                                    .background(SafePathColors.primaryBlue)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(step.title)
                                        .font(.title3.bold())
                                        // Highlight title if it says "Do not"
                                        .foregroundColor(step.title.lowercased().contains("do not") ? SafePathColors.dangerRed : SafePathColors.textPrimary)
                                    
                                    Text(step.description)
                                        .font(.body)
                                        .foregroundColor(SafePathColors.textSecondary)
                                        .lineSpacing(6)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Right Column: Kit List
                    if !guide.requiredKit.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Required Kit List")
                                .font(.title2.bold())
                                .foregroundColor(SafePathColors.textPrimary)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 16) {
                                ForEach(guide.requiredKit) { item in
                                    HStack(alignment: .top, spacing: 16) {
                                        Text("•")
                                            .font(.title2.bold())
                                            .foregroundColor(SafePathColors.textPrimary)
                                        Text(item.name)
                                            .font(.title3.weight(.medium))
                                            .foregroundColor(SafePathColors.textPrimary)
                                    }
                                }
                            }
                        }
                        .padding(32)
                        .frame(width: 350)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                    }
                }
            }
            .padding(40)
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(SafePathColors.primaryBlue)
                        .font(.system(size: 24, weight: .semibold))
                }
            }
            ToolbarItem(placement: .principal) {
                Text("First Aid")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(SafePathColors.textPrimary)
            }
        }
    }
}
