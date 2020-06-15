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
    private let remove: Bool
        
    init(isHidden: Bool, remove: Bool) {
        self.isHidden = isHidden
        self.remove = remove
        
    }

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                if remove {
                    EmptyView()
                } else {
                    content.hidden()
                }
            } else {
                content
            }
        }
    }
}


extension View {
    func isHidden(hidden: Bool, remove: Bool) -> some View {
        self.modifier(HiddenModifier(isHidden: hidden, remove: remove))
    }
}
