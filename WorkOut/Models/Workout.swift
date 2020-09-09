//
//  WorkoutJSON.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

class Workout: Codable, Identifiable, Equatable {

    var _id: String
    var name: String
    var description = ""
    var exerciseList: [ExerciseSet] = []
    
    enum CodingKeys: CodingKey {
        case _id, name, description, exerciseList
    }

    
    init(name: String, description: String, exerciseList: [ExerciseSet]) {
        self._id = UUID().uuidString
        self.name = name
        self.description = description
        self.exerciseList = exerciseList
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        //try container.encode(exerciseList.map { $0._id }, forKey: .exerciseList)
        try container.encode(exerciseList, forKey: .exerciseList)
        
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try container.decode(String.self, forKey: ._id)
        exerciseList = try container.decode([ExerciseSet].self, forKey: .exerciseList)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)

    }
    
    
    var totalSeconds: Int {
        var totalSeconds = 0
        for exerciseSet in self.exerciseList {
            totalSeconds += exerciseSet.time + exerciseSet.restTime
        }
        guard let lastExerciseSet = self.exerciseList.first(where: { $0.order == self.exerciseList.count - 1 }) else {
            return totalSeconds
        }
        
        // subtracting the restTime of the last exercise since that will be the end of the workout
        return totalSeconds - lastExerciseSet.restTime
    }
    var totalTime: String {

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
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        lhs._id == rhs._id
    }
}
