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
    @EnvironmentObject var locationViewModel: LocationSearchViewModel

    func updateUIView(_ uiView: UIViewType, context: Context) {
        
        if let coordinate = locationViewModel.selectedLocationCoordinate {
            context.coordinator.addAndSelectAnnotion(withCoordinate: coordinate)
            context.coordinator.configurePolyline(withDestinationCoordiante: coordinate)
        }
        
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
        
        var userLocation: CLLocationCoordinate2D?
        
        init(parent: UberMapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
         
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocation = userLocation.coordinate
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            parent.mapview.setRegion(region,animated: true)
            
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                let polyline = MKPolylineRenderer(overlay: overlay)
            polyline.strokeColor = UIColor.blue
            polyline.lineWidth = 6
            
            return polyline
        }
        
        func configurePolyline(withDestinationCoordiante coordinate: CLLocationCoordinate2D) {
            guard let userLocation = self.userLocation else { return }
            getDesitnationRoute(from: userLocation, to: coordinate){
                route in
                self.parent.mapview.addOverlay(route.polyline)
            }
        }
        
        func addAndSelectAnnotion(withCoordinate coordinate: CLLocationCoordinate2D){
            
            parent.mapview.removeAnnotations(parent.mapview.annotations)

            let anno = MKPointAnnotation()
            anno.coordinate = coordinate
            parent.mapview.addAnnotation(anno)
            parent.mapview.selectAnnotation(anno, animated: true)
            
            parent.mapview.showAnnotations(parent.mapview.annotations, animated: true)
        }
        
        func getDesitnationRoute(from userLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping(MKRoute)-> Void){
            let userPlacemark = MKPlacemark(coordinate: userLocation)
            let destiPlacemark = MKPlacemark(coordinate: destination)
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: userPlacemark)
            request.destination = MKMapItem(placemark: destiPlacemark)
            let directions = MKDirections(request: request)
            
            directions.calculate{
                response, error in
                if let error = error {
                    return
                }
                guard let route = response?.routes.first else { return }
                completion(route)
            }

        }
        
    }
}
