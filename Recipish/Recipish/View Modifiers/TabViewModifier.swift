//
//  TabViewModifier.swift
//  Recipish
//
//  Created by Azarya Bernard on 18.10.21.
//

import SwiftUI


// MARK: - CardViewModifier
/// A `ViewModifier` for the tab view section on the main view
struct TabViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .tint(.accentColor)
            .frame(
                maxWidth:.infinity,
                maxHeight: .infinity)
            .transition(
                .asymmetric(
                    insertion: .move(edge: .bottom),
                    removal: .move(edge: .bottom)))
            .onAppear() {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor(named: "Green")
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
            .edgesIgnoringSafeArea(.bottom)
    }
}


// MARK: - MainView + TabViewModifier
extension View {
    /// Style a `View` for the tab view and it's animation
    func tabViewModifier() -> some View {
        ModifiedContent(content: self, modifier: TabViewModifier())
    }
}



