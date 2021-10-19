//
//  MockModel.swift
//  
//
//  Created by Azarya Bernard on 12.10.21.
//
import Foundation

// NOT YET IMPLEMENTED
// TODO: Plant to create a favorite or user own recipe view


// MARK: MockModel
public class MockModel: Model {
    
    public convenience init() {
        let testString = "Hello World!"
        self.init(str: testString)
    }
    
}
