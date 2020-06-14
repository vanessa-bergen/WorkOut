//
//  WorkoutDB+CoreDataProperties.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
//

import Foundation
import CoreData


extension WorkoutDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutDB> {
        return NSFetchRequest<WorkoutDB>(entityName: "WorkoutDB")
    }

    @NSManaged public var breakTime: Int32
    @NSManaged public var exerciseTime: Int32
    @NSManaged public var name: String?
    @NSManaged public var exercises: NSSet?
    
    public var wrappedName: String {
        name ?? ""
    }
    
    public var exerciseArray: [ExerciseDB] {
        // convert from NSSet to Set<Wine>
        let set = exercises as? Set<ExerciseDB> ?? []
        
        // converting to a sorted array
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }

}

// MARK: Generated accessors for exercises
extension WorkoutDB {

    @objc(addExercisesObject:)
    @NSManaged public func addToExercises(_ value: ExerciseDB)

    @objc(removeExercisesObject:)
    @NSManaged public func removeFromExercises(_ value: ExerciseDB)

    @objc(addExercises:)
    @NSManaged public func addToExercises(_ values: NSSet)

    @objc(removeExercises:)
    @NSManaged public func removeFromExercises(_ values: NSSet)

}
