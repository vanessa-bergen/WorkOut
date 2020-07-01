//
//  CalculateTotalTime.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-07-01.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation

func calcTotalSeconds(exerciseSet: [ExerciseSet]) -> Int {
    var totalSeconds = 0
    for exercise in exerciseSet {
        totalSeconds += exercise.time + exercise.restTime
    }
    guard let lastExercise = exerciseSet.first(where: { $0.order == exerciseSet.count - 1 }) else {
        return totalSeconds
    }
    
    // subtracting the restTime of the last exercise since that will be the end of the workout
    return totalSeconds - lastExercise.restTime
}

func totalTime(totalSeconds: Int) -> String {
    let (hrs, remainder) = totalSeconds.quotientAndRemainder(dividingBy: 3600)
    let (mins, scds) = remainder.quotientAndRemainder(dividingBy: 60)
    if hrs > 0 {
        return "\(hrs) Hrs \(mins) Mins"
    } else {
        // rounding up to a minute
        if scds >= 30 {
            return "\(mins + 1) Mins"
        }
        return "\(mins) Mins"
    }
}
