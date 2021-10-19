//
//  Favorite.swift
//  Recipish
//
//  Created by Azarya Bernard on 13.10.21.
//

import Foundation
import SwiftUI
import RecipishModel

struct FavoriteView: View {
    
    //MARK: NOT YET IMPLEMENTED
    
    @EnvironmentObject private var model: Model
    
    var body: some View {
        VStack {
            Text("Favorite Placeholder")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("Blue"))
        .foregroundColor(Color("White"))
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(MockModel() as Model)
    }
}
