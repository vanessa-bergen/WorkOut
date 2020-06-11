//
//  ExercisesView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ExercisesView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.name, ascending: true)]
    ) var exercises: FetchedResults<Exercise>
    
    @State private var newExerciseName = ""
    
    @State private var newWorkoutName = ""
    
    var addExerciseDisabled: Bool {
        // if the newExerciseName textfield is empty we want the add button to be disabled
        self.newExerciseName.isEmpty
    }
    
    // will need to change this to a set of exercise entities
    @State private var chosenExercises: Set<Exercise> = []
    
    var body: some View {
        //NavigationView {
            VStack {
                
            List {
                Section(header: Text("Add New")) {
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
                }
                Section(header: Text("Choose From Existing")) {
                    ForEach(exercises, id: \.self) { exercise in
                        MultiSelectedCellView(item: exercise, selectedItems: self.$chosenExercises)
                        
                    }
                }
                
//                Section {
//                    Button(action: {
//
//                    }) {
//                        Text("Next")
//                            .clipShape(Capsule())
//                            .background(Color.yellow)
//                    }
//
//                }
                
                Section{
                    HStack{
                        TextField("Workout Name", text: self.$newWorkoutName)
                        Button(action: {
                            let newWorkout = Workout(context: self.moc)
                            newWorkout.name = self.newWorkoutName
                            let set = self.chosenExercises as NSSet
                            newWorkout.addToExercises(set)
                            try? self.moc.save()
                            
                        }) {
                            Text("Save workout")
                        }
                    }
                }
            
            }
            .listStyle(GroupedListStyle())
  
            }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
    }
}
