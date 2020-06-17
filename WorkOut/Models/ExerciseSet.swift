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
    //var workoutID: UUID
    var exerciseID: UUID
    var exercise: Exercise
    var time: Int
    var restTime: Int
    // need to specify the order of the exercises
    var order: Int
    
    init(exerciseID: UUID, exercise: Exercise, time: Int, restTime: Int, order: Int) {
        //self.workoutID = workoutID
        self.exerciseID = exerciseID
        self.exercise = exercise
        self.time = time
        self.restTime = restTime
        self.order = order
    }
}

