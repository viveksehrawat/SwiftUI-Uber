//
//  LocationSearchViewModel.swift
//  Uber
//
//  Created by Vivek Sehrawat on 31/08/23.
//

import Foundation
import MapKit

class LocationSearchViewModel: NSObject, ObservableObject {
    @Published var results = [MKLocalSearchCompletion]()
    @Published var selectedLocationCoordinate: CLLocationCoordinate2D?
    
    private let searchCompleter = MKLocalSearchCompleter()
    
    var queryFragment: String = "" {
        didSet {
            searchCompleter.queryFragment = queryFragment
        }
    }
    
    override init() {
        super.init()
        searchCompleter.delegate = self
    }
    
   
    
    func selectLocation(_ locationSearch: MKLocalSearchCompletion) {
        
        
        locationSearchQuery(forLocalSearchCompletion: locationSearch) { response, error in
               if let error = error {
                   print(error.localizedDescription)
                   return
               }

               guard let item = response?.mapItems.first else {
                   return
               }

               let coordinate = item.placemark.coordinate
               
               self.selectedLocationCoordinate = coordinate
           }
       }
       
       func locationSearchQuery(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
           let searchRequest = MKLocalSearch.Request()
           searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
           let search = MKLocalSearch(request: searchRequest)
           search.start(completionHandler: completion)
       }
}

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.results = completer.results
    }
}
