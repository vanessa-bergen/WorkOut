//
//  WorkoutJSON.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

class Workout: Codable, Identifiable {
    let id = UUID()
    var name: String
    // number of times to repeat the set
    var repeats: Int = 0
    var exerciseList: [ExerciseSet] = []
    
    init(name: String) {
        self.name = name
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
        
        private func save() {
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
}
