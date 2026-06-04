import SwiftUI
import Combine

/// Person 3: Emergency Checklist view — connected to PreparednessViewModel.
struct ChecklistView: View {
    @EnvironmentObject var viewModel: PreparednessViewModel
    @State private var selectedCategory: KitCategory? = nil // nil = "All"
    @State private var isNavigatingToCustomize = false

    var filteredItems: [ChecklistItem] {
        guard let cat = selectedCategory else { return viewModel.emergencyKit }
        return viewModel.emergencyKit.filter { $0.category == cat }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // 1. Overall Readiness Progress Card
                    readinessCard

                    // 2. Category Filter Pills
                    categoryFilters

                    // 3. Checklist Items List Card
                    itemsListCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .background(SafePathColors.backgroundLight.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(SafePathColors.primaryBlue)
                            .font(.title3)
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("SafePath")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(SafePathColors.primaryBlue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfilePageView()) {
                        Image(systemName: "person.crop.circle.fill")
                            .foregroundColor(SafePathColors.primaryBlue)
                            .font(.title3)
                    }
                }
            }
            .navigationDestination(isPresented: $isNavigatingToCustomize) {
                CustomizeChecklistView()
            }
            .task {
                if viewModel.emergencyKit.isEmpty {
                    await viewModel.getAllItem()
                }
            }
        }
    }

    // MARK: - Overall Readiness Card
    private var readinessCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Overall Readiness")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(SafePathColors.textPrimary)
                Spacer()
                Text("\(viewModel.completedItemsCount)/\(viewModel.totalItemsCount) Completed")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(SafePathColors.primaryBlue)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(SafePathColors.backgroundLight)
                        .frame(height: 10)

                    let percentage = viewModel.totalItemsCount > 0
                        ? CGFloat(viewModel.completedItemsCount) / CGFloat(viewModel.totalItemsCount)
                        : 0
                    RoundedRectangle(cornerRadius: 6)
                        .fill(SafePathColors.primaryBlue)
                        .frame(width: geo.size.width * percentage, height: 10)
                        .animation(.easeInOut, value: percentage)
                }
            }
            .frame(height: 10)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    // MARK: - Category Filters
    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All" pill
                Button(action: { selectedCategory = nil }) {
                    Text("All")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(selectedCategory == nil ? .white : SafePathColors.primaryBlue)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil ? SafePathColors.primaryBlue : SafePathColors.lightBlueCard)
                        .cornerRadius(20)
                }

                // Category pills
                ForEach(KitCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category.displayName)
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(selectedCategory == category ? .white : SafePathColors.primaryBlue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? SafePathColors.primaryBlue : SafePathColors.lightBlueCard)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }

    // MARK: - Items List Card
    private var itemsListCard: some View {
        VStack(spacing: 0) {
            Text("Emergency Checklist")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(SafePathColors.primaryBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 16)

            if viewModel.isLoading {
                ProgressView("Loading items...")
                    .padding()
            } else if filteredItems.isEmpty {
                Text("No items in this category.")
                    .foregroundColor(SafePathColors.textSecondary)
                    .padding()
            } else {
                VStack(spacing: 0) {
                    ForEach(filteredItems) { item in
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                Button(action: {
                                    Task { await viewModel.toggleItem(item) }
                                }) {
                                    Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                        .font(.title2)
                                        .foregroundColor(item.isChecked ? SafePathColors.primaryBlue : .gray)
                                }

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(item.name)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(item.isChecked ? SafePathColors.textSecondary : SafePathColors.textPrimary)
                                        .strikethrough(item.isChecked, color: SafePathColors.textSecondary)
                                    if let qty = item.quantity {
                                        Text("Qty: \(qty) • \(item.category.displayName)")
                                            .font(.caption)
                                            .foregroundColor(SafePathColors.textSecondary)
                                    }
                                }

                                Spacer()

                                // Priority Badge
                                Text(item.priority.rawValue)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(priorityColor(item.priority))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(priorityColor(item.priority).opacity(0.1))
                                    .cornerRadius(8)
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 16)

                            Divider()
                                .padding(.horizontal, 16)
                        }
                    }
                }
            }

            // Add Item Button
            Button(action: { isNavigatingToCustomize = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Item")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                }
                .foregroundColor(SafePathColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                        .foregroundColor(SafePathColors.textSecondary.opacity(0.5))
                )
                .padding(16)
            }
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    private func priorityColor(_ priority: ChecklistPriority) -> Color {
        switch priority {
        case .high:   return SafePathColors.dangerRed
        case .medium: return SafePathColors.primaryBlue
        case .low:    return SafePathColors.safeGreen
        }
    }
}

#Preview {
    ChecklistView()
        .environmentObject(PreparednessViewModel())
}
