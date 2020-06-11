//
//  MultiSelectedCellView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct MultiSelectedCellView: View {
    @Environment(\.managedObjectContext) var moc
    let item: Exercise
    @Binding var selectedItems: Set<Exercise>
    
    var body: some View {
        HStack {
            Text(item.wrappedName)
            Spacer()
            if selectedItems.contains(item) {
                Image(systemName: "minus.circle.fill")
                    .foregroundColor(.red)
            } else {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.green)
            }
        }
        
        // making the whole row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            print("tapped")
            if self.selectedItems.contains(self.item) {
                self.selectedItems.remove(self.item)
            } else {
                
                self.selectedItems.insert(self.item)
            }
            print(self.selectedItems)
        }
        // this only works if the list is in a section 
        .listRowBackground(self.selectedItems.contains(item) ? Color.blue.opacity(0.3) : Color.clear)
        
        
    }
}

