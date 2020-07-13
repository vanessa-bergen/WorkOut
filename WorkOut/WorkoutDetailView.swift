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
    @Binding var selectedTab: Int
    
    @State private var showingDeleteAlert = false
    @State private var navigate = false
    @State private var selectTimerView = 0
    
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                VStack {
                    Text(self.workout.name)
                        .font(.title)
                    Text(self.workout.description)
                        .font(.headline)
                    Text(self.workout.totalTime)
                        .font(.headline)
                }
                .padding()
                .frame(width: geo.size.width * 0.9, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                )
                .padding()
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
                    NavigationLink(destination: TimerView(workout: self.workout)) {

                        Text("Start Workout")
                            .buttonStyle()

                    }
                    .padding()
                    Spacer()
                }
            }
        }

        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                Button(action: {
                    self.navigate = true
                    
                }) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }
                Button(action: {
                    self.showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .imageScale(.large)
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
        .sheet(isPresented: $navigate) {
            CreateStepsView(workout: .constant(self.workout), selectedTab: self.$selectedTab, sheetPresented: self.$navigate)
                .environmentObject(self.savedWorkouts)
                .accentColor(.turquiose)
        }
    }
    
    func deleteWorkout() {
        self.savedWorkouts.delete(workout)
        presentationMode.wrappedValue.dismiss()
    }
}
