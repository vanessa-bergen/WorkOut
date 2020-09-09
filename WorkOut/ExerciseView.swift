//
//  PageView1.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ExerciseView: View {
    
    //@ObservedObject var savedExercises = Exercises()
    @EnvironmentObject var savedWorkouts: Workouts
    @EnvironmentObject var savedExercises: Exercises
    
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
            CreateNewExerciseView(newExerciseName: self.$newExerciseName, newExerciseDescription: self.$newExerciseDescription)
                .padding(.bottom)
            
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
    
    func createExercise() {
        let newExercise = Exercise(name: self.newExerciseName, description: self.newExerciseDescription)
        
        guard let encoded = try? JSONEncoder().encode(newExercise) else {
            print("Failed to encode exercise")
            return
        }
        
        let url = URL(string: "http://165.232.56.142:3004/exercise")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            // if we get a success response, append the exercise to the exercises list, that way we won't need to make another call to the server since we know it worked
            print(response)
            
            do {
                let decodedExercise = try JSONDecoder().decode(Exercise.self, from: data)
                print("it worked for exercise \(decodedExercise.name) \(decodedExercise.description)")
                self.savedExercises.add(decodedExercise)
            
            } catch {
                print("Error: \(error)")
            }

        }.resume()
    }
    
}

