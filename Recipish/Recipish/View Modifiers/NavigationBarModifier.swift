//
//  NavigationBarModifier.swift
//  Recipish
//
//  Created by Azarya Bernard on 17.10.21.
//

import SwiftUI


struct NavigationBarModifier: ViewModifier {
    @Binding var isOpened: Bool
    
    @Binding var showFilter: Bool
    
    var showFilterButton: Bool
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button(action: {
                        withAnimation {
                            self.isOpened.toggle()
                        }
                    }) {
                        Text("Recipish")
                            .bold()
                            .font(Font.system(size: 32))
                            .foregroundColor(Color("White"))
                    }.buttonStyle(PlainButtonStyle())
                        .padding(.top, -4)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showFilterButton {
                        Button(action: {
                            withAnimation {
                                showFilter.toggle()
                            }
                        }) {
                            Image(systemName: "line.3.horizontal.decrease")
                                .font(.system(size: 22))
                                .foregroundColor(Color("White"))
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .navigationTitle("")
            /// wanted to do this but the it gives a lot of log message warning
            .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - NavigationBarModifier
extension View {
    /// Style a `View` for the navigation view's bar title
    func navigationBarModifier(isOpened: Binding<Bool>, showFilter: Binding<Bool> = .constant(false), showFilterButton: Bool = false) -> some View {
        ModifiedContent(content: self, modifier: NavigationBarModifier(isOpened: isOpened, showFilter: showFilter, showFilterButton: showFilterButton))
    }
}
