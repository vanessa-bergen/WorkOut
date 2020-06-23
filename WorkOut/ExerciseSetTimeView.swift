//
//  ExerciseSetTimeView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-16.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ExerciseSetTimeView: View {
    
    @State private var showingExerciseTimePicker = false
    @State private var showingBreakTimePicker = false
    
    @Binding var exerciseSelections: [Int]
    @Binding var breakSelections: [Int]
    
    private let data: [[String]] = [
        Array(0...59).map { "\($0)" },
        ["Minutes"],
        Array(0...59).map { "\($0)" },
        ["Seconds"]
    ]
    
    var body: some View {
        
        VStack {
            
            Button(action: {
                self.showingExerciseTimePicker.toggle()
                
            }){
                HStack {
                    VStack(alignment: .leading) {
                        Text("Exercise Time")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text("\(self.exerciseSelections[0])")
                            .font(.largeTitle)
                            
                        +
                        Text("m ")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        +
                            Text("\(self.exerciseSelections[2])")
                            .font(.largeTitle)
                        +
                        Text("s")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        
                        
                    }
                    Spacer()
                    Image(systemName: self.showingExerciseTimePicker ? "chevron.up" : "chevron.down")
                }
                .padding([.leading, .trailing])
            }
            // hide this when the break time picker is open, that way it can take up most of the screen
            .isHidden(hidden: self.showingBreakTimePicker, remove: true)
            
            if self.showingExerciseTimePicker {
                TimePickerView(data: self.data, selections: self.$exerciseSelections)
            }

            Divider()
                .isHidden(hidden: self.showingBreakTimePicker || self.showingExerciseTimePicker, remove: true)
            
            Button(action: {
                self.showingBreakTimePicker.toggle()
            }){
                HStack {
                    VStack(alignment: .leading) {
                        Text("Break Time")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text("\(self.breakSelections[0])")
                            .font(.largeTitle)
                        +
                        Text("m ")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        +
                            Text("\(self.breakSelections[2])")
                            .font(.largeTitle)
                        +
                        Text("s")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        
                    }
                    Spacer()
                    Image(systemName: self.showingBreakTimePicker ? "chevron.up" : "chevron.down")
                }
                .padding([.leading, .trailing])
            }
            // hide this when the exercise time picker is open, that way it can take up most of the screen
            .isHidden(hidden: self.showingExerciseTimePicker, remove: true)
            
            if self.showingBreakTimePicker {
                TimePickerView(data: self.data, selections: self.$breakSelections)
            }
            
            Divider()
        }
    }
}


