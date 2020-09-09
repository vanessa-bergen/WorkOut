//
//  CreateNewExerciseView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-08-27.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct CreateNewExerciseView: View {
    @EnvironmentObject var savedExercises: Exercises
    
    @Binding var newExerciseName: String
    @Binding var newExerciseDescription: String
    @Binding var exerciseExistsAlert: Bool
    
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
                    //guard let _ = self.savedExercises.exercises.firstIndex(where: { $0.name == self.newExerciseName }) else {
//                        let newExercise = Exercise(name: self.newExerciseName, description: self.newExerciseDescription)
//                        self.savedExercises.add(newExercise)
                        
                        self.createExercise()
                        
                        // reset the text field
                        self.newExerciseName = ""
                        self.newExerciseDescription = ""
                        return
//                    }
//                    self.exerciseExistsAlert = true
                    
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
            print(response ?? "no response")
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            print(statusCode ?? "no status")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print("json return \(json)")
            } catch {
                print(error)
            }
            
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

