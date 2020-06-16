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
    //@Environment(\.managedObjectContext) var moc
    let item: Exercise
    @Binding var selectedItems: [ExerciseSet]
    
    var contains: Bool {
        return selectedItems.contains(where: { $0.exercise == item })
    }
    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                Spacer()
                if selectedItems.contains { $0.exercise == item } {
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
        
        .background(self.selectedItems.contains { $0.exercise == item } ? Color.blue.opacity(0.3) : Color.clear)

        // making the whole row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            if self.contains {
//                if let index = self.selectedItems.firstIndex(of: self.item) {
//                    self.selectedItems.remove(at: index)
//
//                }
                if let index = self.selectedItems.firstIndex(where: { $0.exercise == self.item }) {
                    self.selectedItems.remove(at: index)
                }
            } else {

                //self.selectedItems.append(self.item)
                let newSet = ExerciseSet(exerciseID: self.item.id, exercise: self.item, time: 90, restTime: 10, order: self.selectedItems.count)
                self.selectedItems.append(newSet)
                
            }
        }
    }
}

//struct MultiSelectedScrollView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    
//    static var previews: some View {
//        let exercise = ExerciseDB(context: self.moc)
//        exercise.name = "Burpees"
//        
//        return MultiSelectedScrollView(item: exercise, selectedItems: .constant([exercise]))
//    }
//}
