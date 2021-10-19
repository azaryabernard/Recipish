//
//  QuickFilterView.swift
//  Recipish
//
//  Created by Azarya Bernard on 15.10.21.
//

import Foundation
import RecipishModel
import SwiftUI


struct QuickFilterView: View {
    /// To dismiss the sheet view
    @Environment(\.dismiss) var dismiss
    
    /// Filter list for updating and saving states
    /// the filtering itself occurs on RecipishModel.SearchRecipe
    @Binding var filterList: [String: String]
    
    /// to update the original hits (recipes) list when form is saved
    var updateFunction: () -> Void
    
    
    var body: some View {
        NavigationView {
            self.form
                .onAppear(perform: {})
                .navigationBarTitle("Filter Recipe", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        applyButton
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        clearAllButton
                    }
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var form: some View {
        Form {
            Section(header: Text("Calories per Serving")) {
                HStack {
                    TextField("Min: ", text: unwrap(lhs: $filterList["caloriesMin"], with: ""))
                        .keyboardType(.numberPad)
                    TextField("Max: ", text: unwrap(lhs: $filterList["caloriesMax"], with: ""))
                        .keyboardType(.numberPad)
                }
            }
            
            Section(header: Text("Total Ingredients")) {
                HStack {
                    TextField("Min: ", text: unwrap(lhs: $filterList["ingredientsMin"], with: ""))
                        .keyboardType(.numberPad)
                    TextField("Max: ", text: unwrap(lhs: $filterList["ingredientsMax"], with: ""))
                        .keyboardType(.numberPad)
                }
            }
            
            Section(header: Text("Diet Type")) {
                Picker("Diet Type", selection: unwrap(lhs: $filterList["dietType"], with: "")) {
                    /// Lists of cuisine Types from the developer web pages
                    let dietTypes = ["Balanced", "High-Fiber", "High-Protein", "Low-Carb", "Low-Fat", "Low-Sodium"]
                    
                    ForEach(dietTypes, id: \.self) { dietType in
                        Text(dietType)
                    }
                }
            }
            
            // TODO: Implement multiple health labels filtering (?)
            Section(header: Text("Health Label")) {
                Picker("Health Label", selection: unwrap(lhs: $filterList["healthLabel"], with: "")) {
                    /// Lists of cuisine Types from the developer web pages
                    let healthLabels = ["Alcohol-Cocktail", "Alcohol-Free", "Celery-Free", "Crustacean-Free", "Dairy-Free", "Egg-Free",
                                        "Fish-Free", "Fodmap-Free", "Gluten-Free", "Immuno-Supportive", "Keto-Friendly", "Kidney-Friendly",
                                        "Low-Potassium", "Low-Sugar", "Lupine-Free", "Mollusk-Free", "Mustard-Free", "No-Oil-Added",
                                        "Paleo", "Peanut-Free", "Pescatarian", "Pork-Free", "Red-Meat-Free", "Sesame-Free",
                                        "Shellfish-Free", "Soy-Free", "Sugar-Conscious", "Sulfite-Free", "Tree-Nut-Free", "Vegan",
                                        "Vegetarian", "Wheat-Free"]
                    
                    ForEach(healthLabels, id: \.self) { healthLabel in
                        Text(healthLabel)
                    }
                }
            }
            
            Section(header: Text("Cuisine Type")) {
                Picker("Cuisine Type", selection: unwrap(lhs: $filterList["cuisineType"], with: "")) {
                    /// Lists of cuisine Types from the developer web pages
                    let cuisineTypes = ["American", "Asian", "British", "Caribbean", "Central Europe", "Chinese",
                                        "Eastern Europe", "French", "Indian", "Italian", "Japanese", "Kosher",
                                        "Mediterranean", "Mexican", "Middle Eastern", "Nordic", "South American", "South East Asian"]
                    
                    ForEach(cuisineTypes, id: \.self) { cuisineType in
                        Text(cuisineType)
                    }
                }
            }
            
            Section(header: Text("Meal Type")) {
                Picker("Meal Type", selection: unwrap(lhs: $filterList["mealType"], with: "")) {
                    /// Lists of meal Types from the developer web pages
                    let mealTypes = ["Breakfast", "Dinner", "Lunch", "Snack", "TeaTime"]
                    
                    ForEach(mealTypes, id: \.self) { mealType in
                        Text(mealType)
                    }
                }
            }
            
            
        }
        .padding(12)
    }
    
    /// Button that is used to save the edits made to the `Hits`
    private var applyButton: some View {
        Button(action: updateStates) {
            Text("Apply").bold()
        }.disabled(false)
    }
    
    /// Button that is used to clear all filter
    private var clearAllButton: some View {
        Button(action: { filterList.removeAll() }) {
            Text("Clear All")
        }.disabled(false)
    }
    
    /// update the filter list and the hits using the update function
    private func updateStates() {
        updateFunction()
        dismiss()
    }
    
    /// unwrap Binding of optional for binding the Form fields
    private func unwrap<T>(lhs: Binding<T?>, with defaultValue: T) -> Binding<T> {
        Binding(
            get: { lhs.wrappedValue ?? defaultValue },
            set: { lhs.wrappedValue = $0 }
        )
        
    }
}
