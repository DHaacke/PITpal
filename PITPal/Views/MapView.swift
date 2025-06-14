//
//  MapView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import MapKit
import CoreLocation

// 45.79211066654558, -108.56983021628744

struct MapView: View {
    @Environment(LocationsHandler.self) var locationsHandler
//    @Environment(JSONManager.self) var jsonManager
    
//    @Binding var path: [String]
//    @Binding var isNetworkAvailable: Bool
    
    @State private var headingManager = HeadingManager()
    
    @State private var visibleRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.79211066654558, longitude: -108.56983021628744), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @State private var mapSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.79211066654558, longitude: -108.56983021628744), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)))
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    
    @State private var isLoadingLocation: Bool = false
    @State private var lastLoggedLocation2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    @State private var driftBoatImageName: String = "DriftBoat0"
    @State private var currentDriftBoatImage: Int = 0
        
    @Namespace var mapScope
    
    var body: some View {
        ZStack {
            if isLoadingLocation {
                VStack {
                    Text("Loading location...")
                    ProgressView()
                }
            } else {
                VStack {
                    GeometryReader { geo in
                        MapReader { mapProxy in
                            Map(position: $camera, bounds: .none, interactionModes: .all, selection: .constant(nil)) {
                                Annotation("", coordinate: locationsHandler.lastLocation2D) {
                                    Image(self.driftBoatImageName)
                                        .rotationEffect(.degrees(Double(headingManager.lastHeading)))
                                        // .foregroundColor(.blue)
                                }
                            }

                            
                            
                            .simultaneousGesture(DragGesture().onEnded({_ in
                                // print("Drag ended on map")
                            }))
                            .mapScope(mapScope)
                            .mapStyle(.standard(emphasis: .automatic))
                            .mapControls {
                                MapUserLocationButton()
                                MapCompass()
                            }
                            .onAppear {
                                self.camera = .region(MKCoordinateRegion(center: locationsHandler.lastLocation2D, span: mapSpan))
                                updateCameraPosition()
                                isLoadingLocation = false
                            }
                        }  // end of MapReader
                        // .edgesIgnoringSafeArea(.all)
                    }
                    // .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .task(id: locationsHandler.lastLocation2D) {
           isLoadingLocation = false
        }
        .background(ignoresSafeAreaEdges: .vertical)
    }
    
    func updateCameraPosition() {
        let coord = locationsHandler.lastLocation2D
        let userRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: coord.latitude,
                longitude: coord.longitude),
            span: mapSpan
        )
        withAnimation {
            self.camera = .region(userRegion)
        }
        visibleRegion = userRegion
    }
    
}



#Preview {
    MapView()
}
