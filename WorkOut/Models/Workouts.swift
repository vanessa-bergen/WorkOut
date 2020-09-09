//
//  Workouts.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-08-28.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

class Workouts: ObservableObject {
    @Published var workouts: [Workout] = [] {
//        willSet {
//            print("will set workouts")
//            objectWillChange.send()
//        }
        didSet {
            print("workouts set")
        }
    }
    
    var apiClient = APIClient()
    
    static let workoutsKey = "SavedWorkouts"
        
        init() {
            apiClient.fetchData(Workout.self) { (result) in
                switch result {
                case .success(let workouts):
                    print(workouts.map { $0.name })
                    DispatchQueue.main.async {
                        self.workouts = workouts
                    }
                case .failure(let error):
                    print(error)
                    self.workouts = []
                }
            }
        }
        
        func save() {
            objectWillChange.send()
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
            DispatchQueue.main.async {
                self.workouts.append(workout)
                self.workouts.sort { $0.name < $1.name }
            }
        }
    
    func delete(_ workout: Workout) {
        DispatchQueue.main.async {
            if let index = self.workouts.firstIndex(where: { $0.id == workout.id }) {
                self.workouts.remove(at: index)
            }
        }
    }
}

