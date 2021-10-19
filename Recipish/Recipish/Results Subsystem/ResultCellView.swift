//
//  ResultCellView.swift
//  Recipish
//
//  Created by Azarya Bernard on 18.10.21.
//

import Foundation
import SwiftUI
import RecipishModel

struct ResultCellView: View {
    
    internal var hit: Hit
    
    var body: some View {
        HStack(spacing: 16) {
            /// Async Image for the food thumbnail
            if let imgUrl = hit.recipe?.image {
                AsyncImage(url: URL(string: imgUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            } else {
                Image(systemName: "photo")
            }
            
            /// VStack of Title text, calories, and ingredient
            VStack(alignment: .leading) {
                Text(hit.recipe?.label ?? "")
                    .font(.headline)
                    .foregroundColor(Color("BlackWhite"))
                Text(String("\((hit.recipe?.cuisineType ?? []).joined(separator: ", "))").capitalized)
                    .font(.caption)
                    .foregroundColor(Color("Green"))
                Spacer()
                Group {
                    Text(String("\(Int(round(hit.recipe?.calories ?? 0)) / (hit.recipe?.yield ?? 1)) CALORIES"))
                    Text(String("\(hit.recipe?.ingredients?.count ?? 0) INGREDIENTS"))
                    Spacer()
                    Text(String("Source: \(hit.recipe?.source ?? "")"))
                }
                .font(.system(size: 12))
                .foregroundColor(.secondary)
            }
            Spacer()
        }
    }
    
}
