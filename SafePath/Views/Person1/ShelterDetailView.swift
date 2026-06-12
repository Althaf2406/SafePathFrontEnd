import SwiftUI
import Combine
import MapKit

/// Detail screen for a single shelter.
struct ShelterDetailView: View {
    let shelter: Shelter
    @ObservedObject var viewModel: ShelterViewModel
    
    @State private var mapRegion: MKCoordinateRegion
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.selectedTab) var selectedTab
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var userVM: UserManagementViewModel
    
    @StateObject private var familyVM = FamilySafetyViewModel()
    @StateObject private var emergencyVM = EmergencyStatusViewModel()
    
    @State private var showShareSuccess = false
    
    init(shelter: Shelter, viewModel: ShelterViewModel) {
        self.shelter = shelter
        self.viewModel = viewModel
        _mapRegion = State(initialValue: MKCoordinateRegion(
            center: shelter.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Map preview
                mapPreview
                
                // Header
                headerSection
                
                // Capacity
                capacitySection
                
                // Facilities
                facilitiesSection
                
                // Contact info
                contactSection
                
                // Action buttons
                actionButtons
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(SafePathColors.backgroundLight.ignoresSafeArea())
        .navigationTitle("Shelter Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Map Preview
    
    private var mapPreview: some View {
        Map(initialPosition: .region(mapRegion)) {
            Annotation("", coordinate: shelter.coordinate) {
                Image(systemName: "building.2.fill")
                    .font(.title2)
                    .foregroundColor(SafePathColors.accentBlue)
                    .padding(8)
                    .background(Circle().fill(.white))
                    .shadow(radius: 3)
            }
        }
        .frame(height: 200)
        .cornerRadius(16)
        .allowsHitTesting(false)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(shelter.name)
                    .font(SafePathFonts.title)
                    .foregroundColor(SafePathColors.textPrimary)
                Spacer()
                Text(shelter.shelterType.displayName)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(shelter.isOpenArea ? SafePathColors.warningOrange : SafePathColors.accentBlue)
                    .cornerRadius(10)
            }
            
            Label(shelter.address, systemImage: "mappin.circle.fill")
                .font(SafePathFonts.body)
                .foregroundColor(SafePathColors.textSecondary)
            
            HStack(spacing: 16) {
                if let dist = shelter.distanceKm {
                    Label(dist.distanceDisplay, systemImage: "location.fill")
                         .font(SafePathFonts.caption)
                         .foregroundColor(SafePathColors.accentBlue)
                }
                
                Label("Level \(shelter.buildingLevel)", systemImage: "building.fill")
                    .font(SafePathFonts.caption)
                    .foregroundColor(SafePathColors.textSecondary)
                
                if shelter.isOpenArea {
                    Label("Open Area Field", systemImage: "leaf.fill")
                        .font(SafePathFonts.caption)
                        .foregroundColor(SafePathColors.safeGreen)
                }
            }
        }
        .padding(16)
        .safePathCard()
    }
    
    // MARK: - Capacity
    
    private var capacitySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Capacity")
                .font(SafePathFonts.headline)
                .foregroundColor(SafePathColors.textPrimary)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(shelter.capacity)")
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(SafePathColors.accentBlue)
                    Text("Total Estimated Spots")
                        .font(SafePathFonts.caption)
                        .foregroundColor(SafePathColors.textSecondary)
                }
                Spacer()
            }
        }
        .padding(16)
        .safePathCard()
    }

    
    private func capacityStat(value: String, label: String, highlight: Bool = false) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(highlight ? SafePathColors.safeGreen : SafePathColors.textPrimary)
            Text(label)
                .font(SafePathFonts.caption)
                .foregroundColor(SafePathColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Facilities
    
    private var facilitiesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Facilities")
                .font(SafePathFonts.headline)
                .foregroundColor(SafePathColors.textPrimary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(shelter.facilities, id: \.self) { facility in
                    VStack(spacing: 6) {
                        Image(systemName: Shelter.facilityIcon(facility))
                            .font(.title3)
                            .foregroundColor(SafePathColors.accentBlue)
                        Text(Shelter.facilityDisplayName(facility))
                            .font(SafePathFonts.caption)
                            .foregroundColor(SafePathColors.textPrimary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(SafePathColors.accentBlue.opacity(0.06))
                    .cornerRadius(12)
                }
            }
        }
        .padding(16)
        .safePathCard()
    }
    
    // MARK: - Contact
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Emergency Information")
                .font(SafePathFonts.headline)
                .foregroundColor(SafePathColors.textPrimary)
            
            Label("Compatible disasters: \(shelter.disasterTypeSupported.map { $0.capitalized }.joined(separator: ", "))", systemImage: "info.circle.fill")
                .font(SafePathFonts.body)
                .foregroundColor(SafePathColors.textPrimary)
        }
        .padding(16)
        .safePathCard()
    }
    
    // MARK: - Actions
    
    private var actionButtons: some View {
        VStack(spacing: 10) {
            // Start route
            Button(action: {
                NotificationCenter.default.post(name: NSNotification.Name("RouteToShelter"), object: shelter)
                selectedTab.wrappedValue = .map
                dismiss()
            }) {
                Label("Start Route", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                    .font(SafePathFonts.buttonLabel)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(SafePathColors.accentBlue)
                    .cornerRadius(14)
            }
            
            // Share with Family
            Button(action: {
                if let loc = locationService.currentLocation {
                    Task {
                        await familyVM.shareLocation(latitude: loc.latitude, longitude: loc.longitude)
                        if let currentUserId = userVM.currentUser?.id {
                            await familyVM.updateMemberStatus(memberID: currentUserId, status: .evacuating)
                        }
                        await emergencyVM.updateStatus(
                            status: .evacuating,
                            message: "Evakuasi ke shelter: \(shelter.name)",
                            latitude: loc.latitude,
                            longitude: loc.longitude
                        )
                        showShareSuccess = true
                    }
                } else {
                    Task {
                        if let currentUserId = userVM.currentUser?.id {
                            await familyVM.updateMemberStatus(memberID: currentUserId, status: .evacuating)
                        }
                        await emergencyVM.updateStatus(
                            status: .evacuating,
                            message: "Evakuasi ke shelter: \(shelter.name)"
                        )
                        showShareSuccess = true
                    }
                }
            }) {
                Label("Share to Family Alerts", systemImage: "person.2.fill")
                    .font(SafePathFonts.buttonLabel)
                    .foregroundColor(SafePathColors.accentBlue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(SafePathColors.accentBlue.opacity(0.1))
                    .cornerRadius(14)
            }
        }
        .alert("Shared", isPresented: $showShareSuccess) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Tujuan evakuasi Anda berhasil dibagikan ke grup keluarga.")
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ShelterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ShelterDetailView(shelter: .preview, viewModel: ShelterViewModel())
        }
    }
}
#endif

