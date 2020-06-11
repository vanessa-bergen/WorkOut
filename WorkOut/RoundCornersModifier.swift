//
//  RoundCornersModifier.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct RoundCornersModifier: ViewModifier {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
    
}

extension View {
    func roundCorners(radius: CGFloat, for corners: UIRectCorner) -> some View {
        self.modifier(RoundCornersModifier(radius: radius, corners: corners))
    }
}
