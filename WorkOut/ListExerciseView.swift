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
    
    @State private var newExerciseName = ""
    @State private var newExerciseDescription = ""
    @State private var exerciseExistsAlert = false
    @State private var exerciseToEdit: Exercise?
    @State private var showingPopup = false
    
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
        //                    ForEach(0..<self.savedExercises.exercises.count, id:  \.self) { index in
        //                        VStack(alignment: .leading) {
        //                            TextField("Exercise Name", text: self.$savedExercises.exercises[index].name)
        //                                .font(.headline)
        //                            TextField("Exercise Description", text: self.$savedExercises.exercises[index].description)
        //                                .font(.subheadline)
        //
        //                        }
        //
        //                    }
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
                .navigationBarItems(trailing: EditButton())
        }
    }
    
    func onDelete(at offsets: IndexSet) {
        self.savedExercises.delete(at: offsets)
    }
}

struct ListExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ListExerciseView()
    }
}
