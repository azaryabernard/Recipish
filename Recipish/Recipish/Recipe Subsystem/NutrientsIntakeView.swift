//
//  NutrientsIntakeView.swift
//  Recipish
//
//  Created by Azarya Bernard on 15.10.21.
//

import Foundation
import SwiftUI
import RecipishModel


struct NutrientsIntakeView: View {
    
    /// To dismiss the sheet view
    @Environment(\.dismiss) var dismiss
    //  Objects for this detailed custom sheet view
    /// Nutrients is a dictionary of detailed nutrients
    private var nutrients: [String: Total]
    /// Dailies is the same for daily intakes (in percentage)
    private var dailies: [String: Total]
    /// All of them is divided by the serving amount
    private var serving: Int
    
    init(hit: Hit?) {
        self.nutrients = hit?.recipe?.totalNutrients ?? [:]
        self.dailies = hit?.recipe?.totalDaily ?? [:]
        self.serving = hit?.recipe?.yield ?? 1
    }
    
    // TODO: Need Documentation?
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(Array(nutrients.keys), id: \.self) { key in
                    HStack {
                        if let val = nutrients[key] {
                            Text(val.label ?? "-")
                            Spacer()
                            HStack {
                                Text(String(format: "%.1f", (val.quantity ?? 0.0) / Double(serving)) + (val.unit ?? "-"))
                                Spacer()
                                if let perc = dailies[key] {
                                    Text(String(format: "%.1f", (perc.quantity ?? 0.0) / Double(serving)) +  (perc.unit ?? "-"))
                                } else { Text("-") }
                            }
                            .frame(maxWidth: 150)
                            .foregroundColor(.secondary)
                        } else { Text("-") }
                    }
                    .foregroundColor(Color("BlackWhite"))
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarTitle("Nutrients | Daily Intakes", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) { doneButton }
            }
            
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    /// Done Button for closing the sheet view
    private var doneButton: some View {
        Button(action: { dismiss() }) {
            Text("Done")
                .bold()
                .foregroundColor(Color("Red"))
        }.disabled(false)
    }
}
