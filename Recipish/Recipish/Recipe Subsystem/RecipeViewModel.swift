//
//  RecipeViewModel.swift
//  Recipish
//
//  Created by Azarya Bernard on 18.10.21.
//

import Foundation
import SwiftUI
import RecipishModel


class RecipeViewModel: ObservableObject {
    
    /// the clicked hit from the previous result list view
    @Published var hit: Hit?
    
    @Published var showDetail = false
    
    // init and opening variables for ease of use
    @Published var caloriesPerServing: Int
    
    @Published var dailiesPerServing: Int
    
    /// All of them is divided by the serving amount
    @Published var serving: Int
    
    @Published var dietLabels: [String]
    
    @Published var healthLabels: [String]
    
    @Published var lineLimit = 2
    
    @Published var expanded = false
    
    init(_ hit: Hit?) {
        self.hit = hit
        
        let serving = hit?.recipe?.yield ?? 1
        self.caloriesPerServing = Int(round(hit?.recipe?.calories ?? 0)) / serving
        self.dailiesPerServing = Int(round(hit?.recipe?.totalDaily?["ENERC_KCAL"]?.quantity ?? 0)) / serving
        self.serving = serving
        
        self.dietLabels = hit?.recipe?.dietLabels ?? []
        self.healthLabels = hit?.recipe?.healthLabels ?? []
    }
    
    func expand() {
        lineLimit = expanded ? 2 : 10
        expanded.toggle()
    }
}
