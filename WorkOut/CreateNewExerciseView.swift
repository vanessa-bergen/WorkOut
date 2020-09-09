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
    
    // used to force the textfield placeholders to show after textfields have been cleared
    @State private var refresh = false
    
    var apiClient = APIClient()
    
    var addExerciseDisabled: Bool {
        // if the newExerciseName textfield is empty we want the add button to be disabled
        if self.newExerciseName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return true
        }
        // check to see if an exercise exists with the same name
        guard let _ = self.savedExercises.exercises.firstIndex(where: { $0.name == self.newExerciseName }) else {
            return false
        }
        return true
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {

            Text("Create New Exercise")
                .bold()
                .padding([.leading, .trailing, .top])
            Divider()
            HStack {
                VStack {
                    TextField("Exercise Name" + (refresh ? "" : " "), text: self.$newExerciseName)
                    Divider()
                    TextField("Exercise Description (Optional)" + (refresh ? "" : " "), text: self.$newExerciseDescription)
                        
                }
                
                Button(action: {
                    let newExercise = Exercise(name: self.newExerciseName, description: self.newExerciseDescription)
                    self.apiClient.sendData(Exercise.self, for: newExercise, method: .post) { (result) in
                        switch result {
                        case .success((let data, let response)):
                            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                                print("no status code")
                                return
                            }
                            if statusCode == 201 {
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                    print("json return \(json)")
                                } catch {
                                    print(error)
                                }
                                
                                do {
                                    let decodedExercise = try JSONDecoder().decode(Exercise.self, from: data)
                                    print("created exercise \(decodedExercise._id) \(decodedExercise.name)")
                                    self.savedExercises.add(decodedExercise)
                                
                                } catch {
                                    print("Error: \(error)")
                                }
                            }
                            
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                    // reset the text field
                    self.newExerciseDescription = ""
                    self.newExerciseName = ""
                    self.refresh.toggle()
                    
                    return
                    
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
}

