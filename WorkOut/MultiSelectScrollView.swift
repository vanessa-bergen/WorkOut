//
//  MultiSelectedScrollView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import CoreData

struct MultiSelectedScrollView: View {
    @Environment(\.managedObjectContext) var moc
    let item: Exercise
    @Binding var selectedItems: Set<Exercise>
    
    var body: some View {
        VStack {
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
            .padding([.leading, .trailing, .top])
            Divider()
        }
        
        .background(self.selectedItems.contains(item) ? Color.blue.opacity(0.3) : Color.clear)

        // making the whole row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            if self.selectedItems.contains(self.item) {
                self.selectedItems.remove(self.item)
            } else {

                self.selectedItems.insert(self.item)
            }
        }
    }
}

struct MultiSelectedScrollView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let exercise = Exercise(context: self.moc)
        exercise.name = "Burpees"
        
        return MultiSelectedScrollView(item: exercise, selectedItems: .constant([exercise]))
    }
}
