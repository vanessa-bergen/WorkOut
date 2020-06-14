//
//  ExerciseSEt.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation

class ExerciseSet: Codable, Identifiable {
    let id = UUID()
    var workoutID: UUID
    var exerciseID: UUID
    var exercise: Exercise
    var time: Int
    // need to specify the order of the exercises
    var order: Int
}
