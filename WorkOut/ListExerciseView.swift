//
//  ListExerciseView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-07-02.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ListExerciseView: View {
    @EnvironmentObject var savedExercises: Exercises
    
    @State private var editMode: EditMode = .inactive
    @State private var newExerciseName = ""
    @State private var newExerciseDescription = ""
    @State private var exerciseExistsAlert = false
    @State private var exerciseToEdit: Exercise?
    @State private var showingPopup = false
    @State private var deleteWarning = false
    @State private var indexSetToDelete: IndexSet?
    
    var apiClient = APIClient()
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ZStack {
                    VStack(alignment: .leading) {
                        CreateNewExerciseView(newExerciseName: self.$newExerciseName, newExerciseDescription: self.$newExerciseDescription, exerciseExistsAlert: self.$exerciseExistsAlert)
                        
                        Text("Exercises")
                            .bold()
                            .padding([.leading, .trailing, .top])
                        
                        Divider()
                        
                        List {
                            ForEach(self.savedExercises.exercises, id: \._id) { exercise in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(exercise.name)
                                            .font(.headline)
                                        if !exercise.description.isEmpty {
                                            Text(exercise.description)
                                                .font(.subheadline)
                                        }
                                    }
                                    
                                    Spacer()
                                    Button(action: {
                                        self.exerciseToEdit = exercise
                                        self.showingPopup = true
                                    }){
                                        Image(systemName: "square.and.pencil")
                                            .imageScale(.large)
                                    }
                                }
                            }
                            .onDelete(perform: self.onDelete)
                        }
                    }
                    if self.showingPopup {
                        EditExercisePopup(exercise: self.$exerciseToEdit, showingPopup: self.$showingPopup)
                            .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.5)
                            .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
                            .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color.black, lineWidth: 1))
                    }
                    
                }
            }
            .navigationBarTitle("Exercises")
                // todo change this to delete button, need to do a delete of the exercise and delete it from the exercise sets
            .navigationBarItems(
                trailing:
                Button(action: {
                    self.editMode.toggle()
                }) {
                    Text(self.editMode.title)
                }
            )
            .environment(\.editMode, self.$editMode)
            .alert(isPresented: self.$deleteWarning) {
                Alert(
                    title: Text("Warning! Are you sure you want to delete this?"),
                    message: Text("When deleting an exercise, it will be removed from all workouts"),
                    primaryButton: .destructive(Text("Delete")) {
                        // indexSetToDelete will be set before in the onDelete
                        guard let indexSet = self.indexSetToDelete else {
                            return
                        }
                        for index in indexSet {
                            self.apiClient.sendData(Exercise.self, for: self.savedExercises.exercises[index], method: .delete) { (result) in
                                switch result {
                                case .success((let data, let response)):
                                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                                        print("no status code")
                                        return
                                    }
                                    if statusCode == 200 {
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                            print("json return for exercise deleted \(json)")
                                        } catch {
                                            print("json serialization failed \(error)")
                                        }
                                        
                                        self.savedExercises.delete(at: index)
                                    }
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                        
                    },
                    secondaryButton: .cancel())
            
            }
        }
    }
    
    func onDelete(at offsets: IndexSet) {
        self.deleteWarning = true
        self.indexSetToDelete = offsets
    }
}

extension EditMode {
    var title: String {
        self == .active ? "Done" : "Delete"
    }

    mutating func toggle() {
        self = self == .active ? .inactive : .active
    }
}

struct ListExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ListExerciseView()
    }
}
