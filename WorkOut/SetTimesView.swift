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

    @Binding var chosenExercises: [ExerciseSet]
    @Binding var exerciseTime: Int
    @Binding var breakTime: Int
    
    @State private var showingExerciseTimePicker = false
    @State private var showingBreakTimePicker = false
    
    @State private var exerciseSelections = [0,0,0,0]
    @State private var breakSelections = [0,0,0,0]
    
//    init(chosenExercises: Binding<[ExerciseDB]>) {
//        self._chosenExercises = chosenExercises
//    }
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 10) {
                
                Button(action: {
                    self.showingExerciseTimePicker.toggle()
                }){
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("Exercise Time")
                                .foregroundColor(.black)
                                .font(.headline)
                            
                            Text("\(self.exerciseSelections[0]):\(self.exerciseSelections[2])")
                                .foregroundColor(.black)
                                .font(.headline)
                            
                        }
                        
                        Spacer()
                        Image(systemName: self.showingExerciseTimePicker ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .foregroundColor(.darkTeal)
                            .imageScale(.large)
                    }
                    .padding()
                    .frame(width: geo.size.width * 0.95)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                    )
                    
                }
                .padding(.top)
                if self.showingExerciseTimePicker {
                    TimePickerView(data: self.data, selections: self.$exerciseSelections)
                }
                
                
                
                Button(action: {
                    self.showingBreakTimePicker.toggle()
                }){
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rest Time")
                                .foregroundColor(.black)
                                .font(.headline)
                            
                            Text("\(self.breakSelections[0]):\(self.breakSelections[2])")
                                .foregroundColor(.black)
                                .font(.headline)
                        }
                        
                        Spacer()
                        Image(systemName: self.showingBreakTimePicker ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                            .foregroundColor(.sunrise)
                            .imageScale(.large)
                    }
                    .padding()
                    .frame(width: geo.size.width * 0.95)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.sunrise.opacity(0.5), lineWidth: 2)
                    )
                    
                }
                if self.showingBreakTimePicker {
                    TimePickerView(data: self.data, selections: self.$breakSelections)
                }
                
                
                Spacer()
                
                HStack {
                    PrevNavButton(currentPage: self.$currentPage)
                    Spacer()
                    NextNavButton(currentPage: self.$currentPage)
                }
            }
        }
        .onAppear(perform: setPickerSelections)
    }
    
    func setPickerSelections() {
        let (exM, exS) = self.exerciseTime.quotientAndRemainder(dividingBy: 60)
        exerciseSelections[0] = exM
        exerciseSelections[2] = exS
        
        let (brM, brS) = self.breakTime.quotientAndRemainder(dividingBy: 60)
        breakSelections[0] = brM
        breakSelections[2] = brS
    }
}

//struct SetTimesView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetTimesView(currentPage: .constant(0))
//    }
//}
