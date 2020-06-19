//
//  WorkoutDetailView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var savedWorkouts: Workouts
    
    @Binding var workout: Workout
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.totalTime)
                .padding(.leading)
                .font(.title)
            ListWorkoutView(chosenExercises: $workout.exerciseList)
            HStack {
                Spacer()
                NavigationLink(destination: TimerView(workout: workout)) {
                    
                    Text("Start Workout")
                        .buttonStyle()
                    
                }
                .padding()
                Spacer()
            }
        }
        .navigationBarTitle(workout.name)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title:
                Text("Delete Workout"),
                message: Text("Are you sure?"),
                primaryButton: .destructive(Text("Delete")) {
                    self.deleteWorkout()
                },
                secondaryButton: .cancel())
        }
    }
    
    func deleteWorkout() {
        self.savedWorkouts.delete(workout)
        presentationMode.wrappedValue.dismiss()
    }
}

//struct WorkoutDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailView()
//    }
//}
