import SwiftUI

struct ShelterDetailWatchView: View {
    let shelter: WatchShelter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(shelter.name)
                    .font(.headline)
                
                Divider()
                
                DetailRow(title: "Address", value: shelter.address)
                DetailRow(title: "Type", value: shelter.type)
                DetailRow(title: "Capacity", value: shelter.capacity)
                DetailRow(title: "Disaster Support", value: shelter.disasterTypes)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Shelter")
    }
}
