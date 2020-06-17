//
//  WorkoutJSON.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

class Workout: Codable, Identifiable {
    let id = UUID()
    var name: String
    // number of times to repeat the set
    var repeats: Int = 0
    var exerciseList: [ExerciseSet] = []
    
    init(name: String) {
        self.name = name
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
}

class Workouts: ObservableObject {
    @Published private(set) var workouts: [Workout]
    
    static let workoutsKey = "SavedWorkouts"
        
        init() {
            
            let filename = FileManager.documentsDirectoryURL
                .appendingPathComponent(Self.workoutsKey)
            do {
                let data = try Data(contentsOf: filename)
                self.workouts = try JSONDecoder().decode([Workout].self, from: data)
            } catch {
                self.workouts = []
            }
        }
        
        func save() {
           do {
            let filename = FileManager.documentsDirectoryURL
                .appendingPathComponent(Self.workoutsKey)
            let data = try JSONEncoder().encode(workouts)
                try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func add(_ workout: Workout) {
            workouts.append(workout)
            save()
        }
    
    func delete(_ workout: Workout) {
        if let index = self.workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
        }
        save()
    }
}
