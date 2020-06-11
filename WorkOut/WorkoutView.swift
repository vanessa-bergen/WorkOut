//
//  WorkoutView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(
        entity: Workout.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.name, ascending: true)]
    ) var workouts: FetchedResults<Workout>
    
    @Binding var selectedTab: Int
    
    @State private var selectedWorkout = ""
    @State private var showingExerciseView = false
    
    @State private var currentPage = 0
    @State private var chosenExercises: Set<Exercise> = []
    @State private var exerciseSelections: [Int] = [0, 0, 10, 0]
    @State private var breakSelections: [Int] = [0, 0, 10, 0]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {

//                    NavigationLink(destination:
//                        PagerView(pageCount: 3, currentIndex: self.$currentPage) {
//                            PageView1(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseSelections, breakTime: self.$breakSelections)
//                            SetTimesView(currentPage: self.$currentPage, chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseSelections, breakTime: self.$breakSelections)
//                            PageView3(chosenExercises: self.$chosenExercises, exerciseTime: self.$exerciseSelections, breakTime: self.$breakSelections)
//
//                        }
//                        .environment(\.managedObjectContext, self.moc)
//                    ){
                        HStack {
                            Text("Create New Workout")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(width: geometry.size.width * 0.9)
                        .background(LinearGradient(gradient: Gradient(colors: [.darkTeal, .lightTeal]), startPoint: .leading, endPoint: .trailing))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            self.selectedTab = 1
                        }
                        
                    
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.gray.opacity(0.5), lineWidth: 2)
                        )
                    //}
                        
                    .padding()
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(self.workouts, id: \.self) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(workout.wrappedName)
                                                .foregroundColor(.black)
                                            Text("Total Time: 30 Mins")
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.black)
                                        
                                    }
                                }
                                .padding()
                                .frame(width: geometry.size.width * 0.9)
                                .background(LinearGradient(gradient: Gradient(colors: [.darkTeal, .lightTeal]), startPoint: .leading, endPoint: .trailing))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                
                            
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.gray.opacity(0.5), lineWidth: 2)
                                )
                                
                                
                            }
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("Select Workout"))

            
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView(selectedTab: .constant(0))
    }
}
