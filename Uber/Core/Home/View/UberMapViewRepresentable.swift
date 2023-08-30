//
//  UberMapViewRepresentable.swift
//  Uber
//
//  Created by Vivek Sehrawat on 30/08/23.
//


import SwiftUI
import MapKit

struct UberMapViewRepresentable: UIViewRepresentable{
    let mapview = MKMapView()
    let locationManger = LocationManager()
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        
        mapview.isRotateEnabled = false
        mapview.showsUserLocation = true
        mapview.userTrackingMode = .follow
        mapview.delegate =  context.coordinator
        
        return mapview
    }
    
}

extension UberMapViewRepresentable{
    class MapCoordinator: NSObject, MKMapViewDelegate{
        let parent: UberMapViewRepresentable
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            parent.mapview.setRegion(region,animated: true)
            
        }
    }
}
