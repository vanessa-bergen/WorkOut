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
    
    let item: Exercise
    @Binding var selectedItems: [ExerciseSet]
    @Binding var exerciseTime: Int
    @Binding var breakTime: Int
    
    
    var contains: Bool {
        return selectedItems.contains(where: { $0.exercise == item })
    }
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.headline)
                    Text(item.description)
                        .font(.subheadline)
                }
                
                
                Spacer()
                if self.contains {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                } else {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                }
            }
            .padding()
            
            Divider()
        }
        
        .background(self.contains ? Color.blue.opacity(0.3) : Color.clear)

        // making the whole row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            if self.contains {

                if let index = self.selectedItems.firstIndex(where: { $0.exercise == self.item }) {
                    self.selectedItems.remove(at: index)
                }
            } else {
                let newSet = ExerciseSet(exercise: self.item, time: self.exerciseTime, restTime: self.breakTime, order: self.selectedItems.count)
                self.selectedItems.append(newSet)
            }
        }
    }
}

