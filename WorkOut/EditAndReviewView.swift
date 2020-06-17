//
//  PageView3.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct EditAndReviewView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var savedWorkouts: Workouts

    @Binding var currentPage: Int
    @Binding var chosenExercises: [ExerciseSet]
    @Binding var exerciseTime: Int
    @Binding var breakTime: Int
    @Binding var selectedTab: Int
    
    @State private var newWorkoutName = ""
    @State var editMode: Bool = false
    @State var warningMsgShown = false
    @State var showingPopup = false
    @State private var editExercise: ExerciseSet?
    
    
    
    var totalTime: String {
        if !chosenExercises.isEmpty {
            let totalExerciseTime = exerciseTime * chosenExercises.count
            let totalBreakTime = breakTime * (chosenExercises.count - 1)
            let totalSeconds = totalExerciseTime + totalBreakTime
            
            let (hrs, remainder) = totalSeconds.quotientAndRemainder(dividingBy: 3600)
            let (mins, scds) = remainder.quotientAndRemainder(dividingBy: 60)
            if hrs > 0 {
                return "\(hrs) Hrs \(mins) Mins"
            } else {
                // rounding up to a minute
                if scds >= 30 {
                    return "\(mins + 1) Mins"
                }
                return "\(mins) Mins"
            }
        } else {
            return "0"
        }
    }
    
    var saveWorkoutDisabled: Bool {
        self.newWorkoutName.isEmpty
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading) {
                   
                    TextField("Workout Name", text: self.$newWorkoutName)
                        .font(.title)
                        .padding([.leading, .trailing, .top])
                    Text("Please add a name for the Workout")
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .isHidden(hidden: !self.warningMsgShown, remove: true)
                        .padding([.leading, .trailing])
                        

                    Text("Total Time: \(self.totalTime)")
                        .font(.subheadline)
                        .padding()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.editMode.toggle()
                        }) {
                            if self.editMode {
                                Text("Done")
                                    .padding([.top, .leading, .trailing])
                            } else {
                                Text("Reorder List")
                                    .padding([.top, .leading, .trailing])
                            }
                        }
                    }
                    List {
                        ForEach(self.chosenExercises) { exercise in
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(exercise.exercise.name)
                                            .font(.headline)
                                        Text("\(exercise.time / 60):\(exercise.time % 60)")
                                            .font(.headline)
                                            .opacity(0.8)
                                    }
                                    HStack {
                                        if exercise.restTime > 0 {
                                            Text("Rest")
                                                .font(.subheadline)
                                            Text("\(exercise.restTime / 60):\(exercise.restTime % 60)")
                                                .font(.subheadline)
                                                .opacity(0.8)
                                        } else {
                                            Text("No Rest")
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
                        let newWorkout = Workout(name: self.newWorkoutName)
                        newWorkout.exerciseList = self.chosenExercises
                        self.savedWorkouts.add(newWorkout)
                        
                        self.chosenExercises = []
                        self.currentPage = 0
                        self.selectedTab = 0
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Workout")
                                .buttonStyle()
                            Spacer()
                        }
                    }
                    .disabled(self.saveWorkoutDisabled)
                    .onTapGesture {
                        if self.saveWorkoutDisabled {
                            self.warningMsgShown = true
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
}

//struct PageView3_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView3()
//    }
//}
