//
//  LocationService.swift
//  AppX (iOS)
//
//  Created by Melle Meewis on 05/10/2021.
//

import Foundation
import Combine
import MapKit

class LocationService: NSObject, ObservableObject {

    enum LocationStatus: Equatable {
        case idle
        case noResults
        case isSearching
        case error(String)
        case result
    }

    @Published var queryFragment: String = ""
    @Published private(set) var status: LocationStatus = .idle
    @Published private(set) var searchResults: [MKLocalSearchCompletion] = []
    @Published var addresItem: MKMapItem?

    private var queryCancellable: AnyCancellable?
    private let searchCompleter: MKLocalSearchCompleter!

    init(searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()) {
        self.searchCompleter = searchCompleter
        super.init()
        self.searchCompleter.delegate = self
        self.searchCompleter.resultTypes = .address

        queryCancellable = $queryFragment
            .receive(on: DispatchQueue.main)
            // we're debouncing the search, because the search completer is rate limited.
            // feel free to play with the proper value here
            .debounce(for: .milliseconds(250), scheduler: RunLoop.main, options: nil)
            .sink(receiveValue: { fragment in
                self.status = .isSearching
                if !fragment.isEmpty {
                    self.searchCompleter.queryFragment = fragment
                } else {
                    self.status = .idle
                    self.searchResults = []
                }
        })
    }
    
    func performMKLocalSearch(completionResult: MKLocalSearchCompletion, completion: @escaping (Bool) -> Void) {
        let request = MKLocalSearch.Request(completion: completionResult)
        let search = MKLocalSearch(request: request)
        search.start { [unowned self] (response, error) in
                guard error == nil else {
                    print("ERROR")
                    return
                }
            
            self.addresItem = response?.mapItems.first
            if self.addresItem != nil {
                completion(true)
            }
            else {
                completion(false)
            }
        }
    }
    
    func resetSearchResults() {
        self.searchResults = []
        self.queryFragment = ""
    }
}

extension LocationService: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Depending on what you're searching, you might need to filter differently or
        // remove the filter altogether. Filtering for an empty Subtitle seems to filter
        // out a lot of places and only shows cities and countries.
        self.searchResults = completer.results//.filter({ $0.subtitle == "" })
        self.status = completer.results.isEmpty ? .noResults : .result
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.status = .error(error.localizedDescription)
    }
}
