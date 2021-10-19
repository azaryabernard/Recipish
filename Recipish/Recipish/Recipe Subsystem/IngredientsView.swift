//
//  File.swift
//  Recipish
//
//  Created by Azarya Bernard on 15.10.21.
//

import Foundation
import SwiftUI
import RecipishModel


struct IngredientsView: View {
    
    private var ingredients: [Ingredient]
    /// All of them is divided by the serving amount
    
    init(ingredients: [Ingredient]) {
        self.ingredients = ingredients
    }
    
    var body: some View {
        ForEach(ingredients) { ingredient in
            HStack {
                if let img = ingredient.image {
                    AsyncImage(url: URL(string: img)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 84, height: 84)
                } else {
                    Image(systemName: "photo")
                }
                Text(ingredient.text ?? "-")
                Spacer()
            }
        }
    }
}
