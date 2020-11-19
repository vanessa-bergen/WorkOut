//
//  WorkoutView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    
    @EnvironmentObject var savedWorkouts: Workouts
    
    @Binding var selectedTab: Int
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack {

                    HStack {
                        Text("Create New Workout")
                            .foregroundColor(.white)
                            .bold()
                            
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width: geometry.size.width * 0.9)
                    .background(LinearGradient(gradient: Gradient(colors: [.darkestTeal, .darkTeal]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onTapGesture {
                        self.selectedTab = 1
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.white, lineWidth: 2)
                    )
                    .shadow(color: Color.gray.opacity(0.5), radius: 5)
                    .padding()
                    
                    if !self.savedWorkouts.workouts.isEmpty {
                        Divider()
                    }
                    
                    ScrollView {
                        VStack(spacing: 15) {
                            // need to add this check since it is a ScrollView, if the workouts array starts out empty, it needs something to calculate initial size
                            if self.savedWorkouts.workouts.isEmpty {
                                HStack {
                                    Spacer()
                                }
                            }
                            ForEach(self.savedWorkouts.workouts, id: \._id) { workout in
                                
                                NavigationLink(destination: WorkoutDetailView(workout: .constant(workout), selectedTab: self.$selectedTab)) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(workout.name)
                                                .foregroundColor(.white)
                                                .font(.headline)
                                                .bold()

                                            Text(workout.totalTime)
                                                .foregroundColor(.white)
                                                .font(.subheadline)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)

                                    }
                                }
                                .padding()
                                .frame(width: geometry.size.width * 0.9)
                                .background(LinearGradient(gradient: Gradient(colors: [.darkestTeal, .darkTeal]), startPoint: .leading, endPoint: .trailing))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .strokeBorder(Color.white, lineWidth: 2)
                                )
                                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 1, y: 1)
                            }
                        }
                        .padding()
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
