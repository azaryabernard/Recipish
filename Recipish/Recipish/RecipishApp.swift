//
//  RecipishApp.swift
//  Recipish
//
//  Created by Azarya Bernard on 19.10.21.
//

import SwiftUI

@main
struct RecipishApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
