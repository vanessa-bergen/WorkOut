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
        entity: WorkoutDB.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorkoutDB.name, ascending: true)]
    ) var workouts: FetchedResults<WorkoutDB>
    
    @Binding var selectedTab: Int
    
    @State private var selectedWorkout = ""
    @State private var showingExerciseView = false
    
    @State private var currentPage = 0
    @State private var chosenExercises: Set<ExerciseDB> = []
    @State private var exerciseSelections: [Int] = [0, 0, 10, 0]
    @State private var breakSelections: [Int] = [0, 0, 10, 0]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {

                    HStack {
                        Text("Create New Workout")
                            .foregroundColor(.darkBlue)
                            .bold()
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.darkBlue)
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
                    
                        
                    .padding()
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(self.workouts, id: \.self) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(workout.wrappedName)
                                                .foregroundColor(.darkBlue)
                                                .font(.headline)
                                                .bold()
                                            Text("Total Time: 30 Mins")
                                                .foregroundColor(.darkBlue)
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.darkBlue)
                                        
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
