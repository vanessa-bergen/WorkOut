//
//  Exercises.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-14.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

class Exercises: ObservableObject {
    @Published var exercises: [Exercise] = [] {
        didSet {
            print("set")
            
            //self.save()
        }
    }
    
    static let exercisesKey = "SavedExercises"
    
    var apiClient = APIClient()
    
    init() {
        apiClient.fetchData(Exercise.self) { (result) in
            switch result {
            case .success(let exercises):
                print(exercises.map { $0.name })
                self.exercises = exercises
            case .failure(let error):
                print(error)
                self.exercises = []
            }
        }
    }
    
    
    private func save() {
       do {
        let filename = FileManager.documentsDirectoryURL
            .appendingPathComponent(Self.exercisesKey)
        let data = try JSONEncoder().encode(exercises)
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func add(_ exercise: Exercise) {
        DispatchQueue.main.async {
            self.exercises.append(exercise)
            self.exercises.sort(by: { $0.name < $1.name })
        }
        //save()
    }
    
    func delete(at offset: Int) {
        DispatchQueue.main.async {
            self.exercises.remove(at: offset)
        }
    }
    
    
}
