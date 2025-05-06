//
//  LocationPickerView.swift
//  MyLoveSpot-V2
//
//  Created by Quentin Brejoin on 5/6/25.
//

import SwiftUI
import MapKit

struct LocationPickerView: View {
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var address: String
    @Binding var isPresented: Bool
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var mapView: MKMapView = MKMapView()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search locations", text: $searchText)
                        .onChange(of: searchText) {
                            searchLocations()
                        }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if !searchResults.isEmpty {
                    List {
                        ForEach(searchResults, id: \.self) { item in
                            Button(action: {
                                selectLocation(item)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(item.name ?? "Unknown Location")
                                        .font(.headline)
                                    Text(item.placemark.formattedAddress ?? "")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .frame(height: min(CGFloat(searchResults.count * 60), 300))
                }
                
                MapViewRepresentable(
                    region: $region,
                    selectedLocation: $selectedLocation,
                    address: $address
                )
            
                if let location = selectedLocation {
                    VStack {
                        Text("Selected Location")
                            .font(.headline)
                        Text("Lat: \(location.latitude), Long: \(location.longitude)")
                            .font(.subheadline)
                        if !address.isEmpty {
                            Text(address)
                                .font(.subheadline)
                        }
                    }
                    .padding()
                }
                

                Button(action: {
                    isPresented = false
                }) {
                    Text("Confirm Location")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedLocation != nil ? Color.black : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(selectedLocation == nil)
                .padding()
            }
            .navigationBarTitle("Pick Location", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                }
            )
        }
    }
    
    private func searchLocations() {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching for locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            searchResults = response.mapItems
        }
    }
    
    private func selectLocation(_ item: MKMapItem) {
        let coordinate = item.placemark.coordinate
        selectedLocation = coordinate
        address = item.placemark.formattedAddress ?? ""
        
        withAnimation {
            region.center = coordinate
        }
        
        searchText = ""
        searchResults = []
    }
    
    private func lookupLocation(at coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else {
                address = "Unknown location"
                return
            }
            
            address = [
                placemark.thoroughfare,
                placemark.locality,
                placemark.postalCode,
                placemark.country
            ]
            .compactMap { $0 }
            .joined(separator: ", ")
        }
    }
}

extension MKPlacemark {
    var formattedAddress: String? {
        let components = [
            thoroughfare,
            locality,
            postalCode,
            country
        ]
        return components.compactMap { $0 }.joined(separator: ", ")
    }
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    @Binding var selectedLocation: CLLocationCoordinate2D?
    @Binding var address: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let longPressGesture = UILongPressGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleLongPress(_:))
        )
        longPressGesture.minimumPressDuration = 0.5
        mapView.addGestureRecognizer(longPressGesture)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.setRegion(region, animated: true)
        mapView.removeAnnotations(mapView.annotations)
        
        if let location = selectedLocation {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Selected Location"
            mapView.addAnnotation(annotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let mapView = gesture.view as! MKMapView
                let point = gesture.location(in: mapView)
                
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                
                parent.selectedLocation = coordinate
                parent.region.center = coordinate
                
                lookupLocation(at: coordinate)
            }
        }
        
        private func lookupLocation(at coordinate: CLLocationCoordinate2D) {
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                guard let placemark = placemarks?.first, error == nil else {
                    self.parent.address = "Unknown location"
                    return
                }
                
                self.parent.address = [
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.postalCode,
                    placemark.country
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
            }
        }
    }
}
