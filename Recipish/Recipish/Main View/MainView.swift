//
//  ContentView.swift
//  Recipish
//
//  Created by Azarya Bernard on 12.10.21.
//

import SwiftUI
import RecipishModel


struct MainView: View {
    /// The `Model` as environment object
    /// `not implemted yet!` will be use later for the favorites view (personal)
    @EnvironmentObject private var model: Model
    /// Use only this State Variable for the View with binding of the entire app
    @State var isOpened: Bool = false
    
    
    var body: some View {
        VStack(spacing: 4) {
            //  MARK: Welcome View
            //  Start Button
            /// initialize the App's welcome page and press button for the main TabView
            if !isOpened {
                Text("Recipish")
                    .bold()
                    .font(Font.system(size: 64))
                    .foregroundColor(Color("White"))
                    .padding(.top, -64)
                Button("Find Recipes!") {
                    withAnimation {
                        isOpened.toggle()
                    }
                }.foregroundColor(Color("Blue"))
            }
            //  MARK: Main TabView when started
            /// switches between the search functionality view and the favorites (not implemented)
            else {
                /// to trigger the ignoring of top edge safe area, somehow it doesn't work using normal function
                Rectangle().frame(width: 0, height: 0)
                TabView {
                    SearchView(isOpened: $isOpened).environmentObject(model)
                        .tabItem {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Find Recipes")
                        }
                    FavoriteView()
                        .tabItem {
                            Image(systemName: "star")
                            Text("Your Favorites")
                        } //  TODO: Implement the view to save your own creation (tabItem)
                }
                .tabViewModifier()
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        ).background(
            Color("Green").ignoresSafeArea()
        ).edgesIgnoringSafeArea(.bottom)
    }
}


struct MainView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView()
            .environmentObject(MockModel() as Model)
    }
}
