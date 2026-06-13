import SwiftUI

struct DisasterPreparationDetailPadView: View {
    let guide: DisasterPreparationGuide
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                // Header
                HStack(spacing: 24) {
                    Image(systemName: guide.iconName)
                        .font(.system(size: 64))
                        .foregroundColor(.blue)
                        .frame(width: 120, height: 120)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(guide.title)
                            .font(.system(size: 40, weight: .bold))
                        Text(guide.description)
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding(.horizontal, 40)
                
                // Content
                VStack(alignment: .leading, spacing: 24) {
                    HStack {
                        Image(systemName: "list.bullet.clipboard.fill")
                        Text("Handling Procedures")
                    }
                    .font(.title2.bold())
                    .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(guide.handlingProcedures, id: \.self) { item in
                            HStack(alignment: .top, spacing: 16) {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 8))
                                    .foregroundColor(.blue)
                                    .padding(.top, 8)
                                Text(item)
                                    .font(.body)
                            }
                        }
                    }
                    .padding(32)
                    .background(Color.white)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 40)
            }
            .padding(.vertical, 40)
        }
        .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
    }
}
