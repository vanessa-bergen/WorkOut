//
//  WorkoutJSON.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation

class Workout: Codable, Identifiable {
    let id = UUID()
    var name: String
    // number of times to repeat the set
    var repeats: Int
    var exerciseList: [ExerciseSet]
}
