//
//  SearchRecipe.swift
//  Recipish
//
//  Created by Azarya Bernard on 13.10.21.
//

import Foundation
import SwiftUI
import RecipishModel


struct SearchView: View {
    /// The 'Model' as environment object
    /// not implemted yet! will be use later for the favorites view (personal)
    @EnvironmentObject private var model: Model
    
    /// The `SearchViewModel` object that manages the content of the view
    @ObservedObject private var viewModel: SearchViewModel
    
    /// Binding variable from the beginning of the app
    @Binding var isOpened: Bool
    
    /// The init of this view  for binding the isOpened and initializing the SearchViewModel
    init(isOpened: Binding<Bool>) {
        viewModel = SearchViewModel()
        self._isOpened = isOpened
    }
    
    
    var body: some View {
        
        /// The Result View as a destination for the NavigationLink
        let linkDestination = ResultListView(
            searchText: viewModel.text,
            searchQueries: viewModel.queries,
            isOpened: $isOpened)
            .environmentObject(self.model)
        
        
        //  MARK: Main Navigation View
        NavigationView {
            VStack(spacing: 16) {
                /// Search Bar
                searchBar($viewModel.text)

                /// `First NavigationLink` to search according to the given search text and queries
                /// .simultaneousGesture is used to do an action as you press the navigation link
                NavigationLink(destination: linkDestination) {
                    searchButton
                }
                .disabled(viewModel.linkDisabled())
                .simultaneousGesture(TapGesture().onEnded {
                    viewModel.searchRandom(false)
                })
                
                /// `Second NavigationLink` to surprise user with random results (max: 20), refresh to randomize again
                NavigationLink(destination: linkDestination) {
                    surpriseButton
                }
                .disabled(viewModel.linkDisabled())
                .simultaneousGesture(TapGesture().onEnded {
                    viewModel.searchRandom(true)
                })
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("BlueBackground")
                            .resizable()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    )
            .navigationBarModifier(isOpened: $isOpened)
        }
        .navigationViewModifier()
    }
    
    
    // MARK: Helper for the View Items
    /// Search Bar with custom border and padding
    func searchBar(_ text: Binding<String>) -> some View {
        TextField("Find recipe here! ...", text: text)
            .padding(10)
            .padding(.horizontal, 18)
            .background(Color("WhiteBlack").opacity(0.85))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            .foregroundColor(Color("BlackWhite"))
    }
    
    /// searchButton (technically text) for navigation link
    var searchButton: some View {
        Text("Start Cooking!")
            .font(Font.system(size: 20))
            .foregroundColor(viewModel.linkDisabled() ? .gray : Color("White"))
            .padding(.vertical, 12)
            .padding(.horizontal, 24)
            .background(Color("Red").opacity(0.9))
            .cornerRadius(8)
    }
    
    /// surpriseButton (technically text) for navigation link with `random` query flag set
    var surpriseButton: some View {
        Text("Surprise Me!\n(refresh for more)")
            .font(Font.system(size: 16))
            .foregroundColor(viewModel.linkDisabled() ? .gray : Color("Green"))
            .padding(.top, -4)
    }
}



// MARK: Preview
struct SearchView_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchView(isOpened: .constant(true))
            .environmentObject(MockModel() as Model)
    }
}
