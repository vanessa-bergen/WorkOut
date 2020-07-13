//
//  Exercises.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-14.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

class Exercises: ObservableObject {
    @Published var exercises: [Exercise] {
        didSet {
            self.save()
        }
    }
    
    static let exercisesKey = "SavedExercises"
    
    init() {
//        guard let url = Bundle.main.url(forResource: "exercises", withExtension: "json") else {
//            fatalError("Failed to locate file in bundle.")
//        }
//        guard let data = try? Data(contentsOf: url) else {
//            fatalError("Failed to load file from bundle.")
//        }
//        let decoder = JSONDecoder()
//        guard let loaded = try? decoder.decode([Exercise].self, from: data) else {
//            self.exercises = []
//            fatalError("Failed to decode file from bundle.")
//
//        }
//
//        self.exercises = loaded
        
        let filename = FileManager.documentsDirectoryURL
            .appendingPathComponent(Self.exercisesKey)
        do {
            let data = try Data(contentsOf: filename)
            self.exercises = try JSONDecoder().decode([Exercise].self, from: data)
        } catch {
            self.exercises = []
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
        exercises.append(exercise)
        save()
    }
    
    func delete(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
}
