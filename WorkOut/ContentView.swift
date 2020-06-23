//
//  ContentView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
//    init() {
//        UITabBar.appearance().barTintColor = UIColor.white
//    }
    @Environment(\.managedObjectContext) var moc
    
    var savedWorkouts = Workouts()
    
    @State private var selectedTab = 0
    @State private var currentPage = 0
    
    // change these to observed objects?
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
            
            CreateNewView(pageCount: 3, currentIndex: self.$currentPage) {
                
                SetTimesView(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime)
                ExerciseView(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime)
                EditAndReviewView(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseTime, breakTime: self.$breakTime, selectedTab: self.$selectedTab)
                
            }
            
                
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
        .environment(\.managedObjectContext, self.moc)
        .environmentObject(savedWorkouts)
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
