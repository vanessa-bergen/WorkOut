//
//  PageView1.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ExerciseView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)]
    ) var exercises: FetchedResults<Exercise>
    
    @Binding var currentPage: Int
    
    @Binding var chosenExercises: [Exercise]
    @Binding var exerciseTime: [Int]
    @Binding var breakTime: [Int]
    
    @State private var newExerciseName = ""
    
    var addExerciseDisabled: Bool {
        // if the newExerciseName textfield is empty we want the add button to be disabled
        self.newExerciseName.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Create New Exercise")
                .bold()
                .padding([.leading, .trailing, .top])
            Divider()
            HStack {
                TextField("Exercise Name", text: self.$newExerciseName)
                Button(action: {
                    let newExercise = Exercise(context: self.moc)
                    newExercise.name = self.newExerciseName
                    try? self.moc.save()
                    
                    // reset the text field
                    self.newExerciseName = ""
                }) {
                    if addExerciseDisabled {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.gray)
                            .opacity(0.8)
                            .imageScale(.large)
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                        
                    }
                }
                .disabled(addExerciseDisabled)
            }
            .padding([.leading, .trailing])
            Divider()
            
            Text("Choose Exercises From List")
                .bold()
                .padding([.leading, .trailing, .top])
            
            ScrollView {
                VStack(spacing: 0) {
                    Divider()
                    ForEach(exercises, id: \.self) { exercise in
                        MultiSelectedScrollView(item: exercise, selectedItems: self.$chosenExercises)
                    }
                }
            }
            .padding(.bottom)
            
            HStack {
                Spacer()
                NextNavButton(currentPage: $currentPage)
            }
        }
    }
}

//struct PageView1_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView1(currentPage: .constant(0))
//    }
//}
