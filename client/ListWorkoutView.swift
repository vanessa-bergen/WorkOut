//
//  ListWorkoutView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-16.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ListWorkoutView: View {
    @Binding var chosenExercises: [ExerciseSet]
    @State var editMode: Bool = false
    @State var showingPopup = false
    @State private var editExercise: ExerciseSet?
    
    var body: some View {
        GeometryReader { geo in
        ZStack {
            VStack {
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
                                        .foregroundColor(.white)
                                        .font(.subheadline)
                                        .padding(3)
                                        .background(Color.darkTeal)
                                        .clipShape(Capsule())
                                }
                                .padding(.bottom, 10)
                                HStack {
                                    if exercise.restTime > 0 {
                                        Text("Rest")
                                            .font(.subheadline)
                                        Text("\(exercise.restTime / 60):\(exercise.restTime % 60)")
                                            .foregroundColor(.white)
                                            .font(.subheadline)
                                            .padding(3)
                                            .background(Color.sunrise)
                                            .clipShape(Capsule())
                                    } else {
                                        Text("No Rest")
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
            }
            
            if self.showingPopup {
                EditPopupView(showingPopup: self.$showingPopup, exerciseSet: self.$editExercise)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.8)
                    .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
                    .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color.black, lineWidth: 1))
            }
        }
        }
    }
    
    func onMove(source: IndexSet, destination: Int) {
        chosenExercises.move(fromOffsets: source, toOffset: destination)
        // setting the new order
        for (index, item) in self.chosenExercises.enumerated() {
            item.order = index
        }
    }
}

