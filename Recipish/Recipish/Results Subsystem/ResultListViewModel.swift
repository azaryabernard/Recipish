//
//  ResultListViewModel.swift
//  Recipish
//
//  Created by Azarya Bernard on 18.10.21.
//

import Foundation
import RecipishModel
import SwiftUI
import Combine


class ResultListViewModel: ObservableObject {
    
    /// search text to search with the same text on new task or refresh
    private var searchText: String
    /// search queries to search with the changable queries, e. g. on random
    private var searchQueries: [(name: String, value: String)?]
    /// for making the filter form sheet on the next view visible
    /// when the filter button from header view is clicked
    @Published var errorMessage: String?
    /// variable to trigger the filter sheet
    @Published var showFilter: Bool = false
    
    
    // MARK: Variables for the search functionality
    /// The search recipe object, that `process all the queries` in the `url`, in there lies all the hit recipe structures
    internal var searchRecipe = SearchRecipe()
    
    /// publisher and subscriber for the API call
    private var pub: AnyPublisher<Response, Never>? = nil
    
    private var sub: Cancellable? = nil
    
    /// all of the original data (imutable), published for refresh functionality
    @Published var data: Response = emptyResponse()
    
    /// list of hits for the search results
    @Published var hits: [Hit] = []
    
    /// to restore original hits before new filtering or after clearing all filter
    private var originalHits: [Hit] = []
    
    /// Filter list to be filtered by the form sheet
    @Published var filterList: [String: String] = [:]
    
    /// Init only the search text and queries
    init(_ searchText: String, _ searchQueries: [(String, String)?]) {
        self.searchText = searchText
        self.searchQueries = searchQueries
    }
    
    
    func search(directLink: String? = nil) {
        pub = searchRecipe.search(directLink: directLink, toSearch: searchText, queries: searchQueries)
        sub = pub?.sink(receiveValue: { post in
            self.data = post
            self.hits += self.data.hits ?? []
            self.originalHits += self.data.hits ?? [] /// backups
            self.updateRecipes()
            /// tell the app if there is no search result
            if self.hits.isEmpty {
                if let srErrorMessage = self.searchRecipe.errorMessage {
                    self.errorMessage = "Result Not Found:\n\(srErrorMessage)"
                } else {
                    self.errorMessage = "Result Not Found"
                }
            }
            
        })
    }
    
    /// function to filter the hits according to d´the filterList dictionary
    public func updateRecipes() {
        if filterList.isEmpty || filterList.allSatisfy({ $0.value == "" }) {
            return
        }
        self.hits = self.hits
            .filter {
                let calsPerServing: Int = Int($0.recipe?.calories ?? 0) / ($0.recipe?.yield ?? 1)
                let dietTypes = $0.recipe?.dietLabels ?? []
                let healthLabels = $0.recipe?.healthLabels ?? []
                let cuisineTypes = $0.recipe?.cuisineType ?? []
                let ingredients = $0.recipe?.ingredients ?? []
                
                var mealTypes = $0.recipe?.mealType ?? []
                mealTypes = mealTypes.flatMap( { str in
                    return str.split(separator: "/").map({String($0)
                    })
                } )
                return (
                    /// calories in range of min - max
                    calsPerServing >= Int(filterList["caloriesMin"] ?? "") ?? 0
                    && calsPerServing <= Int(filterList["caloriesMax"] ?? "") ?? 10000
                    /// ingredients count in range of min - max
                    && ingredients.count >= Int(filterList["ingredientsMin"] ?? "") ?? 0
                    && ingredients.count <= Int(filterList["ingredientsMax"] ?? "") ?? 10000
                    /// filtering through picker for these tags
                    && (filterList["healthLabel"] == nil || healthLabels.contains(filterList["healthLabel"] ?? ""))
                    && (filterList["dietType"] == nil || dietTypes.contains(filterList["dietType"] ?? ""))
                    && (filterList["cuisineType"] == nil || cuisineTypes.contains(filterList["cuisineType"]?.lowercased() ?? ""))
                    && (filterList["mealType"] == nil || mealTypes.contains(filterList["mealType"]?.lowercased() ?? ""))
                )
            }
    }
    
    
    /// restore filtered or appended hits to its original list
    public func restoreHits() {
        self.hits = self.originalHits
    }
    
    // function for refreshing the page
    func refresh() async {
        /// delete filterList
        filterList = [:]
        /// fetch new data from the beginning
        search(directLink: nil)
        /// restore original (unfiltered)
        hits = data.hits ?? []
    }
    
    //  Infinite Scrolling
    /// This is needed, because for random list there is no next link in the JSON dump,
    /// so the infinite scrolling from the result ListView will not work.
    func scrolling(_ hit: Hit) async {
        if hit == hits.last && !searchQueries.contains(where: { $0?.name == "random" && $0?.value == "true" }) {
            search(directLink: data._links?.next?.href)
        }
    }
    
    /// updating result after filtering
    func updateResults() {
        /// restore the original list, thus clearing filtered list
        restoreHits()
        /// for random, only has max of 20 recipes
        if searchQueries.contains(where: { $0?.name == "random" && $0?.value == "true" }) {
            updateRecipes()
        } else {
            /// load 5  more pages to broaden the search result
            for _  in 1...5 {
                let _ = print("A")
                search(directLink: data._links?.next?.href)
            }
        }
    }
}
