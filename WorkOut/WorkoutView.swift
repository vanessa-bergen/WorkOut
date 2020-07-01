//
//  WorkoutView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WorkoutView: View {
    
    @EnvironmentObject var workouts: Workouts
    
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
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(self.workouts.workouts) { workout in
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
                                        .strokeBorder(Color.lightTeal, lineWidth: 2)
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
