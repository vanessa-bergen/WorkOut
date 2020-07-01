//
//  PageView1.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ExerciseView: View {
    
    @ObservedObject var savedExercises = Exercises()
    @EnvironmentObject var savedWorkouts: Workouts
    
    @Binding var currentPage: Int
    @Binding var workout: Workout?
    @Binding var chosenExercises: [ExerciseSet]
    @Binding var exerciseTime: Int
    @Binding var breakTime: Int

    
    @State private var newExerciseName = ""
    @State private var newExerciseDescription = ""
    @State private var exerciseExistsAlert = false
    
    var addExerciseDisabled: Bool {
        // if the newExerciseName textfield is empty we want the add button to be disabled
        self.newExerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading) {

            Text("Create New Exercise")
                .bold()
                .padding([.leading, .trailing, .top])
            Divider()
            HStack {
                VStack {
                    TextField("Exercise Name", text: self.$newExerciseName)
                    Divider()
                    TextField("Exercise Description (Optional)", text: self.$newExerciseDescription)
                }
                
                Button(action: {
                    guard let index = self.savedExercises.exercises.firstIndex(where: { $0.name == self.newExerciseName }) else {
                        let newExercise = Exercise(name: self.newExerciseName, description: self.newExerciseDescription)
                        self.savedExercises.add(newExercise)
                        
                        // reset the text field
                        self.newExerciseName = ""
                        self.newExerciseDescription = ""
                        return
                    }
                    self.exerciseExistsAlert = true
                    
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

            Text("Select Exercises From List")
                .bold()
                .padding([.leading, .trailing, .top])
            
            ScrollView {
                VStack(spacing: 0) {
                    Divider()
                    ForEach(savedExercises.exercises.sorted(by: {$0.name < $1.name})) { exercise in
                        MultiSelectedScrollView(item: exercise, selectedItems: self.$chosenExercises, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime)
                    }
                }
                
            }
            .padding(.bottom)

            HStack {
                PrevNavButton(currentPage: self.$currentPage)
                Spacer()
                NextNavButton(currentPage: self.$currentPage, isDisabled: false)
                    
            }
        }
        .alert(isPresented: self.$exerciseExistsAlert, content: {
            Alert(title: Text("Error Creating Exercise"), message: Text("An exercise with this name already exists."), dismissButton: .default(Text("Got it!!")))
        })
        .onAppear {
            guard let workout = self.workout else {
                return
            }
            self.chosenExercises = workout.exerciseList
        }

    }
    
}

