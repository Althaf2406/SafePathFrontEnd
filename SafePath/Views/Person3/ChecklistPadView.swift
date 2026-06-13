import SwiftUI
import Combine

struct ChecklistPadView: View {
    @EnvironmentObject var viewModel: PreparednessViewModel
    @State private var selectedCategory: KitCategory? = nil
    @State private var isNavigatingToCustomize = false

    var filteredItems: [ChecklistItem] {
        guard let cat = selectedCategory else { return viewModel.emergencyKit }
        return viewModel.emergencyKit.filter { $0.category == cat }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    readinessCard
                    categoryFilters
                    itemsListCard
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 24)
            }
            .background(SafePathColors.backgroundLight.ignoresSafeArea())
            .navigationTitle("Emergency Checklist")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $isNavigatingToCustomize) {
                CustomizeChecklistPadView()
            }
        }
    }

    private var readinessCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Overall Readiness")
                    .font(.title2.bold())
                    .foregroundColor(SafePathColors.textPrimary)
                Spacer()
                Text("\(viewModel.completedItemsCount)/\(viewModel.totalItemsCount) Completed")
                    .font(.title3.bold())
                    .foregroundColor(SafePathColors.primaryBlue)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(SafePathColors.backgroundLight)
                        .frame(height: 16)

                    let percentage = viewModel.totalItemsCount > 0
                        ? CGFloat(viewModel.completedItemsCount) / CGFloat(viewModel.totalItemsCount)
                        : 0
                    RoundedRectangle(cornerRadius: 8)
                        .fill(SafePathColors.primaryBlue)
                        .frame(width: geo.size.width * percentage, height: 16)
                        .animation(.easeInOut, value: percentage)
                }
            }
            .frame(height: 16)
        }
        .padding(24)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
    }

    private var categoryFilters: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                Button(action: { selectedCategory = nil }) {
                    Text("All")
                        .font(.body.weight(.semibold))
                        .foregroundColor(selectedCategory == nil ? .white : SafePathColors.primaryBlue)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(selectedCategory == nil ? SafePathColors.primaryBlue : SafePathColors.lightBlueCard)
                        .cornerRadius(24)
                }

                ForEach(KitCategory.allCases, id: \.self) { category in
                    Button(action: { selectedCategory = category }) {
                        Text(category.displayName)
                            .font(.body.weight(.semibold))
                            .foregroundColor(selectedCategory == category ? .white : SafePathColors.primaryBlue)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(selectedCategory == category ? SafePathColors.primaryBlue : SafePathColors.lightBlueCard)
                            .cornerRadius(24)
                    }
                }
            }
        }
    }

    private var itemsListCard: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView("Loading items...")
                    .padding()
            } else if filteredItems.isEmpty {
                Text("No items in this category.")
                    .foregroundColor(SafePathColors.textSecondary)
                    .padding()
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(filteredItems) { item in
                        VStack(spacing: 0) {
                            HStack(spacing: 20) {
                                Button(action: {
                                    Task { await viewModel.toggleItem(item) }
                                }) {
                                    Image(systemName: item.isChecked ? "checkmark.square.fill" : "square")
                                        .font(.title)
                                        .foregroundColor(item.isChecked ? SafePathColors.primaryBlue : .gray)
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.name)
                                        .font(.title3.weight(.medium))
                                        .foregroundColor(item.isChecked ? SafePathColors.textSecondary : SafePathColors.textPrimary)
                                        .strikethrough(item.isChecked, color: SafePathColors.textSecondary)
                                    if let qty = item.quantity {
                                        Text("Qty: \(qty) • \(item.category.displayName)")
                                            .font(.body)
                                            .foregroundColor(SafePathColors.textSecondary)
                                    }
                                }

                                Spacer()

                                Text(item.priority.rawValue)
                                    .font(.subheadline.bold())
                                    .foregroundColor(priorityColor(item.priority))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(priorityColor(item.priority).opacity(0.1))
                                    .cornerRadius(12)
                            }
                            .padding(.vertical, 20)
                            .padding(.horizontal, 24)

                            Divider()
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }

            Button(action: { isNavigatingToCustomize = true }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Item")
                        .font(.title3.bold())
                }
                .foregroundColor(SafePathColors.textSecondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                        .foregroundColor(SafePathColors.textSecondary.opacity(0.5))
                )
                .padding(24)
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
