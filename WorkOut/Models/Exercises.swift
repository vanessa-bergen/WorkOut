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
        
//        let filename = FileManager.documentsDirectoryURL
//            .appendingPathComponent(Self.exercisesKey)
//        do {
//            let data = try Data(contentsOf: filename)
//            self.exercises = try JSONDecoder().decode([Exercise].self, from: data)
//        } catch {
//            self.exercises = []
//        }
        
//        let url = URL(string: "http://165.232.56.142:3004/exercise")!
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            do {
//                if let data = data {
//                    
//                    let decodedResponse = try JSONDecoder().decode([Exercise].self, from: data)
//                    
//                    DispatchQueue.main.async {
//                        self.exercises = decodedResponse
//                    }
//                } else {
//                    print("No Data")
//                }
//            } catch {
//                print("Error: \(error)")
//            }
//            
//        }.resume()
        
        apiClient.fetch(Exercise.self) { (result) in
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
        }
        //save()
    }
    
    func delete(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
}
