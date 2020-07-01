//
//  CreateNewView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct CreateNewView<Content: View>: View {
    
    @Binding var currentIndex: Int
    let content: Content
    var title: String {
        switch currentIndex {
        case 0:
            return "Step 1: Name The Workout"
        case 1:
            return "Step 2: Set Default Timers"
        case 2:
            return "Step 3: Add Exercises"
        default:
            return "Step 4: Review Workout"
        }
    }

    init(currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    self.content.frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
                .offset(x: self.translation)
                .animation(.interactiveSpring())

            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("\(self.title)", displayMode: .inline)
        
            
        }
        
    }
}


