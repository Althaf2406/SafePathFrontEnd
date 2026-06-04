import SwiftUI
import Combine

/// Tab-based navigation for SafePath matching the screenshots.
struct AppRouter: View {
    @EnvironmentObject var locationService: LocationService
    @EnvironmentObject var userVM: UserManagementViewModel
    @State private var selectedTab: Tab = .family
    
    enum Tab: String {
        case home     = "Home"
        case map      = "Map"
        case shelter  = "Shelter"
        case family   = "Family"      // Person 2
        case prep     = "Prep"        // Person 3
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // ── Tab 1: Home (Disaster Alerts) ─────────────────────────────
            NavigationStack {
                DisasterAlertView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(Tab.home)
            
            // ── Tab 2: Map ────────────────────────────────────────────────
            MainMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(Tab.map)
            
            // ── Tab 3: Shelter ────────────────────────────────────────────
            NavigationStack {
                ShelterListView()
            }
            .tabItem {
                Label("Shelter", systemImage: "mappin.circle.fill")
            }
            .tag(Tab.shelter)
            
            // ── Tab 4: Family (Person 2 Placeholder UI) ───────────────────
            NavigationStack {
                if let user = userVM.currentUser, !user.familyGroupIDs.isEmpty {
                    EmergencyStatusView()
                } else {
                    FamilyDashboardView()
                }
            }
                .tabItem {
                    Label("Family", systemImage: "person.2.fill")
                }
                .tag(Tab.family)
            
            // ── Tab 5: Prep (Person 3 Placeholder UI) ─────────────────────
            ChecklistView()
                .tabItem {
                    Label("Prep", systemImage: "checklist")
                }
                .tag(Tab.prep)
        }
        .tint(SafePathColors.primaryBlue)
    }
}

// MARK: - Preview
#if DEBUG
struct AppRouter_Previews: PreviewProvider {
    static var previews: some View {
        AppRouter()
            .environmentObject(LocationService())
            .environmentObject(UserManagementViewModel())
    }
}
#endif

//
