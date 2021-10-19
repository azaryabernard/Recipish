//
//  Config.swift
//
//
//  Created by Azarya Bernard on 12.10.21.
//
import Foundation
import Combine

// NOT YET IMPLEMENTED
// TODO: Plant to create a favorite or user own recipe view

/// The model of the Recipish App
public class Model: ObservableObject {
    
    @Published public internal(set) var str: String
    
    init(str: String) {
        self.str = "\(str)\n\(Config.API_KEY)\n\(Config.API_ID)"
    }
    
}
