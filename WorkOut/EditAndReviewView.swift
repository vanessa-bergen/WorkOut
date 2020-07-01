//
//  PageView3.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct EditAndReviewView: View {
    
    @EnvironmentObject var savedWorkouts: Workouts

    @Binding var currentPage: Int
    @Binding var workoutName: String
    @Binding var description: String
    @Binding var workout: Workout?
    @Binding var chosenExercises: [ExerciseSet]
    @Binding var exerciseTime: Int
    @Binding var breakTime: Int
    @Binding var selectedTab: Int
    @Binding var sheetPresented: Bool

    @State var editMode: Bool = false
    @State var warningMsgShown = false
    @State var showingPopup = false
    @State private var editExercise: ExerciseSet?
    
    var totalSeconds: Int {
        calcTotalSeconds(exerciseSet: self.chosenExercises)
    }
    var timeString: String {
        totalTime(totalSeconds: totalSeconds)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading) {
                   
                    VStack {
                        Text(self.workoutName)
                            .font(.title)
                        Text(self.description)
                            .font(.headline)
                            
                        Text("Total Time: \(self.timeString)")
                            .font(.headline)
                            
                    }
                    .padding()
                    .frame(width: geo.size.width * 0.9, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                    )
                    .padding()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.editMode.toggle()
                        }) {
                            if self.editMode {
                                Text("Done")
                                    .foregroundColor(.black)
                                    .padding([.top, .leading, .trailing])
                            } else {
                                Text("Reorder List")
                                    .foregroundColor(.black)
                                    .padding([.top, .leading, .trailing])
                            }
                        }
                    }
                    List {
                        ForEach(self.chosenExercises) { exercise in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(exercise.exercise.name)
                                            .foregroundColor(.darkestTeal)
                                            .font(.headline)
                                        Text("\(exercise.time / 60):\(exercise.time % 60)")
                                            .timeStlye(rest: false)
                                    }
                                    HStack {
                                        
                                        if exercise.restTime > 0 {
                                            Text("Rest")
                                                .foregroundColor(.darkSunrise)
                                                .font(.subheadline)
                                            Text("\(exercise.restTime / 60):\(exercise.restTime % 60)")
                                                .timeStlye(rest: true)
                                        } else {
                                            Text("No Rest")
                                                .foregroundColor(.darkSunrise)
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                Spacer()

                                Button(action: {
                                    self.editExercise = exercise
                                    self.showingPopup = true
                                }) {
                                    Image(systemName: "square.and.pencil")
                                }
                                .padding(.trailing)
                                Button(action: {

                                }) {
                                    Image(systemName: "trash")
                                }


                            }
                        }
                        .onMove(perform: self.onMove)

                    }
                    .environment(\.editMode, self.editMode ? .constant(.active) : .constant(.inactive))
                    
                    
                    
                    Button(action: {
                        guard let workout = self.workout else {
                            let newWorkout = Workout(name: self.workoutName, description: self.description)
                            newWorkout.exerciseList = self.chosenExercises
                            self.savedWorkouts.add(newWorkout)
                            
                            self.reset()
                            return
                        }
                        
                        workout.name = self.workoutName
                        workout.description = self.description
                        workout.exerciseList = self.chosenExercises
                        
                        self.reset()
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Workout")
                                .buttonStyle()
                            Spacer()
                        }
                    }
                    
                    
                    
                    Spacer()
                    HStack {
                        PrevNavButton(currentPage: self.$currentPage)
                        Spacer()
                        
                    }
                }
                .background(self.showingPopup ? Color.black.opacity(0.3) : Color.clear)
                    
                if self.showingPopup {
                    EditPopupView(showingPopup: self.$showingPopup, exerciseSet: self.$editExercise)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.8)
                        .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
                        .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color.black, lineWidth: 1))
                }
            }
            .onAppear {
                // set the list backgroun to clear, that way the background color can be set
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
            
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        chosenExercises.remove(atOffsets: offsets)
    }

    func onMove(source: IndexSet, destination: Int) {
        chosenExercises.move(fromOffsets: source, toOffset: destination)
        // setting the new order
        for (index, item) in self.chosenExercises.enumerated() {
            item.order = index
        }
    }
    
    func reset() {
        self.workoutName = ""
        self.description = ""
        self.chosenExercises = []
        self.currentPage = 0
        // going back to the workout tab
        self.selectedTab = 0
        // closing the sheet view if this is opened for editing from the workout details view
        self.sheetPresented = false
        
    }
}

