import SwiftUI

struct DisasterPreparationGuidePadView: View {
    @StateObject private var viewModel = DisasterPreparationViewModel()
    @Environment(\.dismiss) var dismiss
    
    // Using NotificationViewModel just to simulate the alert
    @StateObject private var notificationViewModel = NotificationViewModel()
    @State private var showingAlert = false
    
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disaster Prep Guides")
                        .font(.largeTitle.bold())
                    
                    Text("Learn how to prepare and respond to various disasters.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 32)
                
                Button(action: {
                    notificationViewModel.simulatePrepGuideNotification(for: "Flood")
                    showingAlert = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "bell.badge.fill")
                            .font(.title3)
                        Text("Simulate Disaster Alert Notification")
                            .font(.title3.bold())
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(Color.orange)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("Notification Sent"), message: Text("A simulated notification for Flood has been sent to the Notification Center."), dismissButton: .default(Text("OK")))
                }
                
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(viewModel.guides) { guide in
                        NavigationLink(destination: DisasterPreparationDetailPadView(guide: guide)) {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top) {
                                    Image(systemName: guide.iconName)
                                        .font(.largeTitle)
                                        .foregroundColor(.blue)
                                        .frame(width: 80, height: 80)
                                        .background(Color.blue.opacity(0.1))
                                        .clipShape(Circle())
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .padding(.top, 10)
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(guide.title)
                                        .font(.title2.bold())
                                        .foregroundColor(.primary)
                                    Text(guide.description)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                        .lineLimit(3)
                                        .multilineTextAlignment(.leading)
                                }
                            }
                            .padding(24)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
            .padding(.vertical, 32)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
