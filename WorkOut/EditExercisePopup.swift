//
//  EditExercisePopup.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-09-04.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct EditExercisePopup: View {
    
    @Binding var exercise: Exercise?
    @Binding var showingPopup: Bool
    @State private var name = ""
    @State private var description = ""
    @State private var errorAlert = false
    
    
    var body: some View {
        
        VStack(alignment: .center) {
            Text("Edit")
                .bold()
                .font(.title)
            TextField("Exercise Name", text: self.$name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.headline)
                .padding([.leading, .trailing])
                
            TextField("Exercise Description", text: self.$description)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.headline)
                .padding()
            Button(action: {
                
                self.exercise?.name = self.name
                self.exercise?.description = self.description
                self.updateExercise(for: self.exercise)
                self.showingPopup = false
            }) {
                Text("Save Changes")
                    .buttonStyle()
            }
        }
        .alert(isPresented: self.$errorAlert) {
            Alert(title: Text("Error Retrieving Exercise"), message: Text("Cannot display the exercise selected. Please try again."), dismissButton: .default(Text("OK")) {
                // close the edit window if the exercise cannot be retrieved
                self.showingPopup = false
                })
        }
        
        .onAppear {
            guard let exercise = self.exercise else {
                self.errorAlert = true
                return
            }
            self.name = exercise.name
            self.description = exercise.description
        }
    }
    
    func updateExercise(for exercise: Exercise?) {
        
        guard let encoded = try? JSONEncoder().encode(exercise) else {
            print("Failed to encode exercise")
            return
        }
        
        let url = URL(string: "http://165.232.56.142:3004/exercise/edit")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print("json return \(json)")
            } catch {
                print(error)
            }
            
            // if we get a success response, add the workout to savedWorkouts, that way we won't need to make another call to the server since we know it worked
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            print(statusCode ?? "no status")
            if statusCode == 201 {
                // do we need to have the right id here - may need to add the returned data?
                //self.savedWorkouts.add(workout)
                print("exercise Saved")
            }

        }.resume()
    }
}
