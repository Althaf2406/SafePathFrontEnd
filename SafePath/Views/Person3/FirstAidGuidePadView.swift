import SwiftUI
import Combine

struct FirstAidGuidePadView: View {
    @StateObject private var viewModel = FirstAidGuideViewModel()
    @Environment(\.dismiss) var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 24),
        GridItem(.flexible(), spacing: 24)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    // Header Details
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("First Aid Guide")
                                .font(.system(size: 40, weight: .bold, design: .rounded))
                                .foregroundColor(SafePathColors.textPrimary)
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                Image(systemName: "icloud.and.arrow.down")
                                    .font(.body)
                                Text("AVAILABLE OFFLINE")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(SafePathColors.safeGreen)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(SafePathColors.safeGreen.opacity(0.15))
                            .cornerRadius(16)
                        }
                        
                        Text("Quick reference guides for emergency medical situations.")
                            .font(.title3)
                            .foregroundColor(SafePathColors.textSecondary)
                    }
                    .padding(.horizontal, 32)
                    
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(SafePathColors.textSecondary)
                        TextField("Search symptoms or injuries...", text: $viewModel.searchQuery)
                            .font(.title3)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(24)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 32)
                    
                    // Guide List
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(viewModel.filteredGuides) { guide in
                            NavigationLink(destination: FirstAidGuideDetailPadView(guide: guide)) {
                                GuideRowPadView(guide: guide)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 40)
                }
                .padding(.top, 32)
            }
            .background(SafePathColors.backgroundLight.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct GuideRowPadView: View {
    let guide: FirstAidGuide
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Left color accent bar
            Rectangle()
                .fill(colorForCategory(guide.category))
                .frame(width: 8)
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    // Icon
                    Image(systemName: guide.iconName ?? "cross.case.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(colorForCategory(guide.category))
                        .frame(width: 56, height: 56)
                        .background(colorForCategory(guide.category).opacity(0.15))
                        .clipShape(Circle())
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(Color.gray.opacity(0.5))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(guide.title)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(SafePathColors.textPrimary)
                    
                    Text(guide.shortDescription)
                        .font(.system(size: 16))
                        .foregroundColor(SafePathColors.textSecondary)
                        .lineLimit(2)
                }
                
                Divider()
                
                HStack(spacing: 8) {
                    Image(systemName: "cross.case")
                        .font(.subheadline)
                        .foregroundColor(SafePathColors.textSecondary)
                    Text("REQUIRED KIT:")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(SafePathColors.textSecondary)
                }
                
                Text(guide.requiredKit.map { $0.name }.joined(separator: ", "))
                    .font(.system(size: 15))
                    .foregroundColor(SafePathColors.textPrimary)
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
        }
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
    
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "cpr", "bleeding": return SafePathColors.dangerRed
        case "burns": return SafePathColors.warningOrange
        case "fractures", "sprain": return SafePathColors.primaryBlue
        default: return SafePathColors.safeGreen
        }
    }
}
