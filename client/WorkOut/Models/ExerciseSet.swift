//
//  ExerciseSEt.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

class ExerciseSet: Codable, Identifiable {
    var _id: String
    var exercise: Exercise
    var time: Int
    var restTime: Int
    // need to specify the order of the exercises
    var order: Int
    
    enum CodingKeys: CodingKey {
        case _id, exercise, time, restTime, order
    }
    
    init(exercise: Exercise, time: Int, restTime: Int, order: Int) {
        self._id = UUID().uuidString
        self.exercise = exercise
        self.time = time
        self.restTime = restTime
        self.order = order
    }
    
    // encode it using the exercise id instead of the whole exercise object
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(_id, forKey: ._id)
        try container.encode(exercise._id, forKey: .exercise)
        try container.encode(time, forKey: .time)
        try container.encode(restTime, forKey: .restTime)
        try container.encode(order, forKey: .order)
    }

    // when decoding it will return the exercise object, not just the id
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try container.decode(String.self, forKey: ._id)
        exercise = try container.decode(Exercise.self, forKey: .exercise)
        time = try container.decode(Int.self, forKey: .time)
        restTime = try container.decode(Int.self, forKey: .restTime)
        order = try container.decode(Int.self, forKey: .order)

    }
}

