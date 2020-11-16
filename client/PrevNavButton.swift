//
//  PrevNavButton.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct PrevNavButton: View {
    @Binding var currentPage: Int
    
    var body: some View {
        Button(action: {
            self.currentPage -= 1
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .font(.headline)
                    .imageScale(.large)
                Text("Last")
                    .foregroundColor(.white)
                    .font(.headline)
                    .bold()
            }
        }
        .padding()
        .background(Color.darkTeal)
        .roundCorners(radius: 20, for: [.topRight, .bottomRight])
        .padding(.bottom)
    }
}

struct PrevNavButton_Previews: PreviewProvider {
    static var previews: some View {
        PrevNavButton(currentPage: .constant(0))
    }
}
