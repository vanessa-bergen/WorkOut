//
//  EditPopupView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-16.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct EditPopupView: View {
    @EnvironmentObject var savedWorkouts: Workouts
    @Binding var showingPopup: Bool
    @Binding var exerciseSet: ExerciseSet?
    @State private var exerciseSelections = [0,0,0,0]
    @State private var breakSelections = [0,0,0,0]
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            Text(self.exerciseSet!.exercise.name)
                .font(.title)
            Divider()
            ExerciseSetTimeView(exerciseSelections: self.$exerciseSelections, breakSelections: self.$breakSelections)
                
            Button(action: {
                self.showingPopup = false
                guard let exerciseSet = self.exerciseSet else {
                    return
                }
                exerciseSet.time = self.exerciseSelections[0] * 60 + self.exerciseSelections[2]
                exerciseSet.restTime = self.breakSelections[0] * 60 + self.breakSelections[2]
                self.savedWorkouts.save()
            }) {
                Text("Save Changes")
                    .buttonStyle()
            }
            .padding(.bottom)
        }
        .frame(height: geo.size.height)
        .onAppear(perform: self.setPickerSelections)
        }
        
    }
    func setPickerSelections() {
        guard let exerciseSet = exerciseSet else {
            return
        }
        let (exM, exS) = exerciseSet.time.quotientAndRemainder(dividingBy: 60)
        exerciseSelections[0] = exM
        exerciseSelections[2] = exS
        
        let (brM, brS) = exerciseSet.restTime.quotientAndRemainder(dividingBy: 60)
        breakSelections[0] = brM
        breakSelections[2] = brS
    }
}


