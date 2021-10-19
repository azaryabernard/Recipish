//
//  NavigationViewModifier.swift
//  Recipish
//
//  Created by Azarya Bernard on 18.10.21.
//

import SwiftUI


struct NavigationViewModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.backgroundColor = UIColor(named: "Green")
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
                UINavigationBar.appearance().tintColor = UIColor(named: "White")
                
                //MARK: For Self
                /// how to change button image:
                //  appearance.setBackIndicatorImage(UIImage(systemName: "arrow.backward"), transitionMaskImage: UIImage(systemName: "arrow.backward"))
            }
    }
}


// MARK: - NavigationBarModifier
extension View {
    /// Style a `View` for the navigation view's bar title
    func navigationViewModifier() -> some View {
        ModifiedContent(content: self, modifier: NavigationViewModifier())
    }
}
