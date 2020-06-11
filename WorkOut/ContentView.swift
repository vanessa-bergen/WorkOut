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
    
    @State private var selectedTab = 0
    @State private var currentPage = 0
    @State private var chosenExercises: [Exercise] = []
    @State private var exerciseSelections: [Int] = [0, 0, 10, 0]
    @State private var breakSelections: [Int] = [0, 0, 10, 0]
    
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
                ExerciseView(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseSelections, breakTime: self.$breakSelections)
                SetTimesView(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseSelections, breakTime: self.$breakSelections)
                PageView3(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseSelections, breakTime: self.$breakSelections)
                
            }
            
            .environment(\.managedObjectContext, self.moc)
            .tabItem {
                Image(systemName: "plus.circle.fill")
                Text("Create New")
            }
            .tag(1)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(2)
        }
        .accentColor(.turquiose)
        .environment(\.managedObjectContext, self.moc)
    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
