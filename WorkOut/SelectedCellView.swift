//
//  SelectedCellView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct SelectedCellView: View {
    
    let item: String
    @Binding var selectedItem: String
    
    var body: some View {
        HStack {
            Text(item)
            Spacer()
            if item == selectedItem {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        // making the whole row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            self.selectedItem = self.item
        }
    }
}


