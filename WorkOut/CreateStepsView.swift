//
//  CreateStepsView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-30.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct CreateStepsView: View {
    @Binding var workout: Workout?
    @Binding var selectedTab: Int
    @Binding var sheetPresented: Bool
    
    @State private var currentPage = 0
    @State private var workoutName = ""
    @State private var description = ""
    @State private var chosenExercises: [ExerciseSet] = []
    @State private var exerciseTime: Int = 90
    @State private var breakTime: Int = 10
    
    var body: some View {
        CreateNewView(currentIndex: self.$currentPage) {
            CreateWorkoutView(currentPage: self.$currentPage, workout: self.$workout, workoutName: self.$workoutName, description: self.$description)
            SetTimesView(currentPage: self.$currentPage, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime)
            ExerciseView(currentPage: self.$currentPage, workout: self.$workout, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime)
            EditAndReviewView(currentPage: self.$currentPage, workoutName: self.$workoutName, description: self.$description, workout: self.$workout, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime, selectedTab: self.$selectedTab, sheetPresented: self.$sheetPresented)

        }
    }
}
