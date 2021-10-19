//
//  RecipishApp.swift
//  Recipish
//
//  Created by Azarya Bernard on 19.10.21.
//

import SwiftUI
import RecipishModel

@main
struct RecipishApp: App {
    /// maybe for core data?
    //let persistenceController = PersistenceController.shared
    @StateObject var model: Model = MockModel()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(model)
            
            //ContentView()
            //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
