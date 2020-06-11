//
//  HiddenModifier.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct HiddenModifier: ViewModifier {

    private let isHidden: Bool
        
    init(isHidden: Bool) {
        self.isHidden = isHidden
        
    }

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            } else {
                content
            }
        }
    }
}


extension View {
    func isHidden(_ hidden: Bool) -> some View {
        self.modifier(HiddenModifier(isHidden: hidden))
    }
}
