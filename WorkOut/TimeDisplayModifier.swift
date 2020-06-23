//
//  TimeDisplayModifier.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-23.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
import SwiftUI

struct TimeDisplay: ViewModifier {
    var rest: Bool

    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .font(.subheadline)
            .padding(5)
            .background(rest ? Color.sunrise : Color.darkTeal)
            .clipShape(Capsule())
        
    }
}

extension View {
    func timeStlye(rest: Bool) -> some View {
        self.modifier(TimeDisplay(rest: rest))
    }
}
