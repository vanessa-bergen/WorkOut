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
            List {
                ForEach(self.workout.exerciseList) { exercise in
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(exercise.exercise.name)
                                    .foregroundColor(.darkestTeal)
                                    .font(.headline)
                                Spacer()
                                Text("\(exercise.time / 60):\(exercise.time % 60)")
                                    .timeStlye(rest: false)
                            }
                            
                            if exercise.order != self.workout.exerciseList.count-1 {
                                HStack {
                                    Text("Rest")
                                        .foregroundColor(.darkSunrise)
                                        .font(.subheadline)
                                    Spacer()
                                    if exercise.restTime > 0 {
                                        Text("\(exercise.restTime / 60):\(exercise.restTime % 60)")
                                            .timeStlye(rest: true)
                                    } else {
                                        Text("No Rest")
                                            .timeStlye(rest: true)
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                }
            }
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
        .navigationBarItems(trailing:
            HStack {
                Button(action: {
                    
                }) {
                    Image(systemName: "square.and.pencil")
                }
                Button(action: {
                    self.showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                }
                
            }
        )
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
