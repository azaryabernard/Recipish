//
//  RecipeView.swift
//  Recipish
//
//  Created by Azarya Bernard on 15.10.21.
//

import Foundation
import RecipishModel
import SwiftUI


struct RecipeView: View {
    
    /// The `RecipeViewModel` object that manages the content of the view
    @ObservedObject var viewModel: RecipeViewModel
    //  binding variables from start view
    @Binding var isOpened: Bool
    
    init(hit: Hit?, isOpened: Binding<Bool>) {
        viewModel = RecipeViewModel(hit)
        self._isOpened = isOpened
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                
                // MARK: Header Section
                self.headerSection
                Spacer(minLength: 8)
                
                // MARK: Nutrition Overview section
                self.nutritionSection
                Spacer(minLength: 24)
                
                
                // MARK: Health and Diet Labels
                Section(header: Text("Health and Diet Labels").bold()) {
                    Divider()
                    Group {
                        Text(((viewModel.dietLabels) + (viewModel.healthLabels)).joined(separator: ", "))
                            .lineLimit(viewModel.lineLimit)
                        Image(systemName: viewModel.expanded ? "chevron.down" : "chevron.up")
                    }
                    .foregroundColor(.secondary)
                    .onTapGesture(perform: {
                        withAnimation {
                            viewModel.expand()
                        }})
                }
                .padding(.horizontal, 8)
                Spacer(minLength: 24)
                
                
                // MARK: Detailed Nutrients Section
                Section(header: Text("Total Nutrients and Daily Intake").bold()) {
                    Divider()
                    Button(action: {
                        withAnimation { viewModel.showDetail.toggle() }
                    }) {
                        HStack {
                            Text("Show Detail")
                            Image(systemName: "eye.circle")
                        }
                    }
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                Spacer(minLength: 24)
                
                
                // MARK: Section: List of Ingredients with images
                if let ingredients = viewModel.hit?.recipe?.ingredients {
                    Section(header: Text("\(ingredients.count) Ingredients").bold()) {
                        Divider()
                        IngredientsView(ingredients: ingredients)
                    }
                    .padding(.horizontal, 8)
                    Spacer(minLength: 24)
                }
                
                
                // MARK: Full Instruction on the link from the original source
                Section(header: Text("Full Instructions").bold()) {
                    Divider()
                    if let link = URL(string: (viewModel.hit?.recipe?.url ?? "")) {
                        Link(destination: link) {
                            HStack {
                                Text("Source: \(viewModel.hit?.recipe?.source ?? "")")
                                Image(systemName: "link")
                            }
                            .foregroundColor(Color("Blue"))
                        }
                        Spacer(minLength: 24)
                    }
                }
                .padding(.horizontal, 8)
            }
            .background(Color("WhiteBlack").opacity(0.83))
            .foregroundColor(Color("BlackWhite"))
            .cornerRadius(8)
            .sheet(isPresented: $viewModel.showDetail) {
                NutrientsIntakeView(hit: viewModel.hit)
            }
            .navigationBarModifier(isOpened: $isOpened)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("BlueBackground")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                )
    }

    
    //  MARK: Header Section
    var headerSection: some View {
        return HStack {
            if let img = viewModel.hit?.recipe?.image {
                AsyncImage(url: URL(string: img)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 128, height: 128)
            } else {
                Image(systemName: "photo")
            }
            Spacer()
            Text(viewModel.hit?.recipe?.label ?? "Title")
                .font(.largeTitle)
                .foregroundColor(Color("White"))
            Spacer()
        }
        .background(Color("Red"))
    }
    
    
    //  MARK: Nutritions Overview Section
    var nutritionSection: some View {
        Group {
            VStack(alignment: .center) {
                HStack(alignment: .center, spacing: 16) {
                    Spacer()
                    Text(viewModel.caloriesPerServing.description)
                    Spacer()
                    Text(String("\(viewModel.dailiesPerServing)%"))
                    Spacer()
                    Text(viewModel.serving.description)
                    Spacer()
                }.font(.system(size: 32))
                HStack(alignment: .center, spacing: 12) {
                    Text("CALORIES / SERVING")
                    Text("DAILY VALUE")
                    Text("SERVINGS")
                }.font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
        }
    }
}

