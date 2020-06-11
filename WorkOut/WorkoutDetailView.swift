//
//  WorkoutDetailView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout
    
    var body: some View {
        VStack {
            List {
                ForEach(workout.exerciseArray, id: \.self) { exercise in
                    Text(exercise.wrappedName)
                }
            }
            NavigationLink(destination: TimerView(workout: workout)) {
                HStack {
                    Image(systemName: "play.fill")
                        .renderingMode(.original)
                    Text("Start Workout")
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
        .navigationBarTitle(workout.wrappedName)
    }
}

//struct WorkoutDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutDetailView()
//    }
//}
