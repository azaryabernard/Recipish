//
//  SearchViewModel.swift
//  Recipish
//
//  Created by Azarya Bernard on 18.10.21.
//

import Foundation
import SwiftUI
import RecipishModel


class SearchViewModel: ObservableObject {
    
    
    // MARK: Other
    /// the search text query
    @Published var text: String = ""
    
    // TODO: Implement advanced filter to edit the queries beforehand
    /// for now only used to pass the random filter
    @Published var queries: [(name: String, value: String)?] = []
    
    
    
    func searchRandom(_ isRandom: Bool) {
        if isRandom {
            queries.append(("random", "true"))
        } else {
            queries.removeAll(where: {$0?.name == "random" && $0?.value == "true"})
        }
    }
    
    func linkDisabled() -> Bool {
        return text.isEmpty
    }
    
}
