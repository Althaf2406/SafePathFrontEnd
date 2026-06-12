import SwiftUI

struct CustomizeChecklistPadView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: PreparednessViewModel
    
    @State private var newItemName = ""
    @State private var newItemQuantity = "1"
    @State private var selectedCategory: KitCategory = .waterFood
    @State private var selectedPriority: ChecklistPriority = .medium

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Info Section
                VStack(spacing: 16) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 64))
                        .foregroundColor(SafePathColors.primaryBlue)
                    Text("Customize Your Kit")
                        .font(.largeTitle.bold())
                    Text("Add specific items that your family needs for survival.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 32)
                
                // Form Section
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Item Name")
                            .font(.headline)
                            .foregroundColor(SafePathColors.textPrimary)
                        TextField("e.g. Inhaler, Extra Batteries", text: $newItemName)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Quantity")
                            .font(.headline)
                            .foregroundColor(SafePathColors.textPrimary)
                        TextField("e.g. 2, 1 pack", text: $newItemQuantity)
                            .padding()
                            .background(Color(UIColor.secondarySystemBackground))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(.headline)
                            .foregroundColor(SafePathColors.textPrimary)
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(KitCategory.allCases, id: \.self) { cat in
                                Text(cat.displayName).tag(cat)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Priority")
                            .font(.headline)
                            .foregroundColor(SafePathColors.textPrimary)
                        Picker("Priority", selection: $selectedPriority) {
                            ForEach(ChecklistPriority.allCases, id: \.self) { prio in
                                Text(prio.rawValue.capitalized).tag(prio)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                .padding(32)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
                .padding(.horizontal, 32)
                
                Button(action: saveItem) {
                    Text("Add to Checklist")
                        .font(.title3.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .background(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : SafePathColors.primaryBlue)
                        .cornerRadius(16)
                }
                .disabled(newItemName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationTitle("Add Custom Item")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveItem() {
        let name = newItemName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }
        
        let item = ChecklistItem(
            name: name,
            category: selectedCategory,
            priority: selectedPriority,
            quantity: newItemQuantity.isEmpty ? nil : newItemQuantity
        )
        Task {
            await viewModel.addCustomItem(item)
            dismiss()
        }
    }
}
