//
//  NewSpotFormView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 5/5/25.
//

import SwiftUI
import MapKit

struct NewSpotFormView: View {
    @Binding var spots: [Spots]
    @Binding var isPresented: Bool
    @Binding var tags: [Tag]
    @Binding var selectedSpot: Spots?
    
    @EnvironmentObject var authManager: AuthenticationManager
    
    @State private var name = ""
    @State private var description = ""
    @State private var address = ""
    @State private var selectedCategories: [String: Bool] = [:]
    @State private var categories: [String] = []
    @State private var selectedLocation: CLLocationCoordinate2D?
    @State private var showingMapPicker = false
    @State private var link = ""
    @State private var image = ""
    @State private var id: Int = 0
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Spot Information")) {
                    TextField("Name", text: $name)
                    
                    VStack(alignment: .leading) {
                        Text("Category").font(.headline)
                        ForEach(categories, id: \.self) { category in
                            Toggle(isOn: Binding(
                                get: { selectedCategories[category] ?? false },
                                set: { selectedCategories[category] = $0 }
                            )) {
                                Text(category)
                            }
                        }
                    }
                    TextField("Information link", text: $link)
                    ZStack(alignment: .leading) {
                        if description.isEmpty {
                            Text("Description")
                                .foregroundColor(.gray)
                                .padding(.leading, 4)
                        }
                        TextEditor(text: $description)
                            .frame(height: 100)
                    }
                }
                
                Section(header: Text("Location")) {
                    TextField("Address", text: $address)
                    
                    Button(action: {
                        showingMapPicker = true
                    }) {
                        HStack {
                            Text(selectedLocation != nil ? "Location Selected" : "Select on Map")
                            Spacer()
                            Image(systemName: "mappin.and.ellipse")
                        }
                    }
                }
                
                Section {
                    Button(action: createNewSpot) {
                        Text("Create Spot")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.black)
                    .disabled(name.isEmpty || selectedLocation == nil)
                }
            }
            .navigationBarTitle("New Spot", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
            )
        }.onAppear {
            self.categories = self.tags.map { $0.name }
            for category in categories {
                if selectedCategories[category] == nil {
                    selectedCategories[category] = false
                }
            }
        }.sheet(isPresented: $showingMapPicker) {
            LocationPickerView(selectedLocation: $selectedLocation, address: $address, isPresented: $showingMapPicker)
        }
        
    }

    private func createNewSpot() {
        guard let location = selectedLocation else { return }
        
        let selectedTags = selectedCategories
                .filter { $0.value }
                .map { $0.key }
        guard let url = URL(string: "http://127.0.0.1:3000/spot/create") else {
            print("Wrong URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["name": name, "description": description, "address": address, "longitude": String(location.longitude), "latitude": String(location.latitude), "logo": "heart.fill", "color": "#FFFFFF", "image": image, "link": link, "tags": selectedTags.joined(separator: ",").isEmpty ? [] : selectedTags]
        print(body)
        if let token = authManager.getJWTToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Token: Not available")
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(IdResponse.self, from: data)
                id = decodedResponse.id
                
                let newSpot = Spots(
                    id: id,
                    name: name,
                    address: address,
                    creator: "me",
                    description: description,
                    rating: "None",
                    image: "",
                    link: link,
                    tags: selectedTags,
                    my_rating: -1,
                    mapInfo: Spots.MapInfo(
                        logo: "heart.fill",
                        color: "#FFFFFF",
                        longitude: String(location.longitude),
                        latitude: String(location.latitude)
                    )
                )
                spots.append(newSpot)
                isPresented = false
                selectedSpot = nil
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)")
            }
            
        }.resume()
    }
}
struct IdResponse: Codable {
    let id: Int
}
