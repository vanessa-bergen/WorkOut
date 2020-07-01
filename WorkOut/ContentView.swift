//
//  ContentView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
        
    var savedWorkouts = Workouts()
    
    @State private var workout: Workout?
    
    @State private var selectedTab = 0
    @State private var currentPage = 0
    
    
    @State private var workoutName = ""
    @State private var description = "Workout Description (Optional)"
    @State private var chosenExercises: [ExerciseSet] = []
    @State private var exerciseTime: Int = 90
    @State private var breakTime: Int = 10
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WorkoutView(selectedTab: $selectedTab)
                .tabItem {
                    Image("weights")
                        .renderingMode(.template)
                    Text("Workout")
                }
                .tag(0)

            CreateStepsView(workout: self.$workout, selectedTab: self.$selectedTab, sheetPresented: .constant(false))
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Create New")
                }
                .tag(1)
            
            ScheduleView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(2)
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(3)

        }
        .accentColor(.turquiose)
        .environmentObject(savedWorkouts)
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
