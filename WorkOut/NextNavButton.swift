//
//  NavigationButtons.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct NextNavButton: View {
    @Binding var currentPage: Int
    var body: some View {
        Button(action: {
            self.currentPage += 1
        }) {
            HStack {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.headline)
                    .bold()
                Image(systemName: "arrow.right")
                    .foregroundColor(.white)
                    .font(.headline)
                    .imageScale(.large)
            }
        }
        .padding()
        .background(Color.darkTeal)
        .roundCorners(radius: 20, for: [.topLeft, .bottomLeft])
        .padding(.bottom)
    }
}

struct NextNavButton_Previews: PreviewProvider {
    static var previews: some View {
        NextNavButton(currentPage: .constant(0))
    }
}
