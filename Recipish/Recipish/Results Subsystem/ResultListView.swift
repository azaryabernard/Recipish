//
//  ResultListView.swift
//  Recipish
//
//  Created by Azarya Bernard on 14.10.21.
//

import Foundation
import SwiftUI
import RecipishModel


struct ResultListView: View {
    /// The 'Model' as environment object
    /// not implemted yet! will be use later for the favorites view (personal)
    @EnvironmentObject private var model: Model
    /// The `ResultListViewModel` object that manages the content of the view
    @ObservedObject var viewModel: ResultListViewModel
    //  binding variables from start view
    @Binding var isOpened: Bool
    
    
    /// The init of this view  for binding the isOpened and initializing the ResultListViewModel
    init(searchText: String, searchQueries: [(String, String)?], isOpened: Binding<Bool>) {
        viewModel = ResultListViewModel(searchText, searchQueries)
        self._isOpened = isOpened
    }
    
    var body: some View {
        /// List for each `SearchRecipe` hits from view model
        List(viewModel.hits) { hit in
            
            /// NavigationLink wrapping all the view
            NavigationLink(destination: RecipeView(hit: hit, isOpened: $isOpened)) {

                /// The Result Cell for each Recipe's Hit
                ResultCellView(hit: hit)
                .task {
                    //  Infinite Scrolling
                    await viewModel.scrolling(hit)
                }
            }
            .listRowBackground(Color("WhiteBlack").opacity(0.83))
        }
        .background(Image("BlueBackground")
                                .resizable()
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        )
        .onAppear {
            UITableView.appearance().backgroundColor = UIColor.clear
        }
        /// List View Modifier with loading  task and refreshable
        .task {
            viewModel.search(directLink: nil) /// Fetch new data from the beginning
        }
        .refreshable {
            await viewModel.refresh() /// refresh by resetting almost all its queries with only search text left
        }
        .sheet(isPresented: $viewModel.showFilter) {
            /// Call to Sheet Form to filter the list, triggrered by showFilter, saved to filterList
            QuickFilterView(filterList: $viewModel.filterList, updateFunction: viewModel.updateResults)
        }
        .overlay(Group {
            /// Display not found message after delay if there are no recipes to fetch
            if let errorMessage = viewModel.errorMessage {
                Text("Wow, such empty...\n(\(errorMessage))")
                    .foregroundColor(.secondary)
            } else if viewModel.hits.isEmpty {
                Text("Loading...")
                    .foregroundColor(.secondary)
            }
        })
        .navigationBarModifier(isOpened: $isOpened, showFilter: $viewModel.showFilter, showFilterButton: true)
    }
}


//  MARK: ResultListView_Previews
struct ResultListView_Previews: PreviewProvider {
    static var previews: some View {
        ResultListView(searchText: "Chicken", searchQueries: [], isOpened: .constant(true))
            .environmentObject(MockModel() as Model)
    }
}
