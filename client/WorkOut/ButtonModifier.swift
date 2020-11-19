//
//  ButtonModifier.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-16.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .background(Color.darkTeal)
            .clipShape(Capsule())
    }
}

extension View {
    func buttonStyle() -> some View {
        self.modifier(ButtonStyle())
    }
}
