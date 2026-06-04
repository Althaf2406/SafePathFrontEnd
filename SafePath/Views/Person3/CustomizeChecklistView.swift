import SwiftUI
import Combine

/// Person 3: Customize Checklist screen matching the visual style in Screenshot 3.
struct CustomizeChecklistView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = CustomizeChecklistViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Details
                headerView
                
                // Form Card
                formCard
                
                // Recently Added Items Section
                recentlyAddedSection
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 32)
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
                HStack(spacing: 6) {
                    Image(systemName: "shield.fill")
                        .foregroundColor(SafePathColors.primaryBlue)
                        .font(.headline)
                    Text("SafePath")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundColor(SafePathColors.primaryBlue)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(SafePathColors.primaryBlue)
                    .font(.title3)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Customize Checklist")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(SafePathColors.primaryBlue)
            
            Text("Update your emergency supplies for specific disaster types.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(SafePathColors.textSecondary)
                .lineLimit(2)
        }
    }
    
    // MARK: - Form Card
    private var formCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Item Name
            VStack(alignment: .leading, spacing: 6) {
                Text("Item Name")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(SafePathColors.textPrimary)
                TextField("e.g. Tactical Flashlight", text: $viewModel.itemName)
                    .padding()
                    .background(SafePathColors.backgroundLight.opacity(0.5))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(SafePathColors.lightBlueCard, lineWidth: 1.5)
                    )
            }
            
            // Category & Quantity Row
            HStack(spacing: 12) {
                // Category Picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("Category")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(SafePathColors.textPrimary)
                    
                    Menu {
                        ForEach(viewModel.categories, id: \.self) { cat in
                            Button(cat.displayName) { viewModel.selectedCategory = cat }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedCategory.displayName)
                                .foregroundColor(SafePathColors.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(SafePathColors.textSecondary)
                                .font(.caption)
                        }
                        .padding()
                        .background(SafePathColors.backgroundLight.opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(SafePathColors.lightBlueCard, lineWidth: 1.5)
                        )
                    }
                }
                
                // Quantity Picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("Quantity")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(SafePathColors.textPrimary)
                    
                    Menu {
                        ForEach(1...10, id: \.self) { num in
                            Button("\(num)") { viewModel.quantity = num }
                        }
                    } label: {
                        HStack {
                            Text("\(viewModel.quantity)")
                                .foregroundColor(SafePathColors.textPrimary)
                            Spacer()
                        }
                        .padding()
                        .background(SafePathColors.backgroundLight.opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(SafePathColors.lightBlueCard, lineWidth: 1.5)
                        )
                    }
                    .frame(width: 100)
                }
            }
            
            // Priority & Disaster Type Row
            HStack(spacing: 12) {
                // Priority Selector
                VStack(alignment: .leading, spacing: 6) {
                    Text("Priority")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(SafePathColors.textPrimary)
                    
                    HStack(spacing: 0) {
                        Button(action: { viewModel.priority = .high }) {
                            Text("High")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(viewModel.priority == .high ? .white : SafePathColors.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(viewModel.priority == .high ? SafePathColors.primaryBlue : SafePathColors.lightBlueCard)
                        }
                        
                        Button(action: { viewModel.priority = .medium }) {
                            Text("Medium")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(viewModel.priority == .medium ? .white : SafePathColors.primaryBlue)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(viewModel.priority == .medium ? SafePathColors.primaryBlue : SafePathColors.lightBlueCard)
                        }
                    }
                    .cornerRadius(10)
                }
                
                // Disaster Type Picker
                VStack(alignment: .leading, spacing: 6) {
                    Text("Disaster Type")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(SafePathColors.textPrimary)
                    
                    Menu {
                        ForEach(viewModel.disasterTypes, id: \.self) { type in
                            Button(type) { viewModel.disasterType = type }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.disasterType)
                                .foregroundColor(SafePathColors.textPrimary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(SafePathColors.textSecondary)
                                .font(.caption)
                        }
                        .padding()
                        .background(SafePathColors.backgroundLight.opacity(0.5))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(SafePathColors.lightBlueCard, lineWidth: 1.5)
                        )
                    }
                }
            }
            .padding(.bottom, 8)
            
            // Save Item Button
            Button(action: {
                viewModel.saveItem()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.arrow.down.fill")
                    Text("Save Item")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(SafePathColors.primaryBlue)
                .cornerRadius(12)
            }
            
            // Delete Item Button (Clear form as demo, normally tied to selected item)
            Button(action: {
                viewModel.resetForm()
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "trash.fill")
                    Text("Clear Form")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(SafePathColors.dangerRed)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(SafePathColors.dangerRed, lineWidth: 1.5)
                )
                .cornerRadius(12)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Recently Added Section
    private var recentlyAddedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("RECENTLY ADDED ITEMS")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(SafePathColors.textSecondary)
                .padding(.horizontal, 4)
            
            VStack(spacing: 12) {
                if viewModel.customItems.isEmpty {
                    Text("No items added yet.")
                        .font(.system(size: 14))
                        .foregroundColor(SafePathColors.textSecondary)
                        .padding()
                } else {
                    ForEach(viewModel.customItems) { item in
                        HStack(spacing: 12) {
                            Image(systemName: iconForCategory(item.category))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(colorForCategory(item.category))
                                .frame(width: 40, height: 40)
                                .background(colorForCategory(item.category).opacity(0.1))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.name)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(SafePathColors.textPrimary)
                                Text("\(item.category.displayName) • Qty: \(item.quantity ?? 1) • \(item.priority.rawValue) Priority")
                                    .font(.system(size: 12))
                                    .foregroundColor(SafePathColors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.deleteItem(id: item.id)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(SafePathColors.dangerRed)
                            }
                        }
                        .padding(12)
                        .background(Color.white)
                        .cornerRadius(16)
                    }
                }
            }
        }
    }
    
    // Helper for category icons
    private func iconForCategory(_ category: KitCategory) -> String {
        switch category {
        case .firstAid: return "cross.case.fill"
        case .lighting: return "flashlight.on.fill"
        case .water: return "drop.fill"
        case .food: return "fork.knife"
        case .communication: return "radio.fill"
        case .navigation: return "map.fill"
        case .clothing: return "tshirt.fill"
        case .tools: return "wrench.and.screwdriver.fill"
        case .hygiene: return "hands.sparkles.fill"
        case .documents: return "doc.fill"
        }
    }
    
    // Helper for category colors
    private func colorForCategory(_ category: KitCategory) -> Color {
        switch category {
        case .firstAid: return SafePathColors.safeGreen
        case .water, .communication, .navigation: return SafePathColors.primaryBlue
        case .lighting, .food: return SafePathColors.warningOrange
        case .tools: return SafePathColors.dangerRed
        default: return SafePathColors.offlineGray
        }
    }
}

#Preview {
    CustomizeChecklistView()
}
