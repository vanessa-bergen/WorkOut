//
//  SetTimesView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-09.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct SetTimesView: View {
    
    @Binding var currentPage: Int
    private let data: [[String]] = [
        Array(0...59).map { "\($0)" },
        ["Minutes"],
        Array(0...59).map { "\($0)" },
        ["Seconds"]
    ]

    @Binding var chosenExercises: Set<Exercise>
    @Binding var exerciseTime: [Int]
    @Binding var breakTime: [Int]
    
    @State private var showingExerciseTimePicker = false
    @State private var showingBreakTimePicker = false
    
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
                        Text("\(exerciseTime[0])")
                            .font(.largeTitle)
                            
                        +
                        Text("m ")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        +
                        Text("\(exerciseTime[2])")
                            .font(.largeTitle)
                        +
                        Text("s")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        
                        
                    }
                    Spacer()
                    Image(systemName: self.showingExerciseTimePicker ? "chevron.up" : "chevron.down")
                }
                .padding()
                
            }
            if self.showingExerciseTimePicker {
                TimePickerView(data: data, selections: $exerciseTime)
            }
            
            Divider()
            
            Button(action: {
                self.showingBreakTimePicker.toggle()
            }){
                HStack {
                    VStack(alignment: .leading) {
                        Text("Break Time")
                            .foregroundColor(.black)
                            .font(.headline)
                        Text("\(breakTime[0])")
                            .font(.largeTitle)
                            
                        +
                        Text("m ")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        +
                        Text("\(breakTime[2])")
                            .font(.largeTitle)
                        +
                        Text("s")
                            .foregroundColor(.black)
                            .font(.subheadline)
                        
                        
                    }
                    Spacer()
                    Image(systemName: self.showingBreakTimePicker ? "chevron.up" : "chevron.down")
                }
                .padding()
                
            }
            if self.showingBreakTimePicker {
                TimePickerView(data: data, selections: $breakTime)
            }
            Divider()
            
            Spacer()
            
            HStack {
                PrevNavButton(currentPage: $currentPage)
                Spacer()
                NextNavButton(currentPage: $currentPage)
            }
        }
    }
}

//struct SetTimesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetTimesView(currentPage: .constant(0))
//    }
//}
