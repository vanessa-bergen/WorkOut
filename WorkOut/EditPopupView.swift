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
        
        VStack {
            Text(self.exerciseSet!.exercise.name)
            Divider()
            ExerciseSetTimeView(exerciseSet: self.$exerciseSet, exerciseSelections: self.$exerciseSelections, breakSelections: self.$breakSelections)
                
            Button(action: {
                self.showingPopup = false
                guard let e = self.exerciseSet else {
                    return
                }
                e.time = self.exerciseSelections[0] * 60 + self.exerciseSelections[2]
                e.restTime = self.breakSelections[0] * 60 + self.breakSelections[2]
                self.savedWorkouts.save()
            }) {
                Text("Save Changes")
                    .buttonStyle()
            }
        }
        
    }
}


