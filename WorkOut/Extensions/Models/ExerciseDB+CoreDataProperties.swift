//
//  ExerciseDB+CoreDataProperties.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
//

import Foundation
import CoreData


extension ExerciseDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseDB> {
        return NSFetchRequest<ExerciseDB>(entityName: "ExerciseDB")
    }

    @NSManaged public var explanation: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var workoutName: NSSet?
    
    public var wrappedName: String {
        name ?? ""
    }

}

// MARK: Generated accessors for workoutName
extension ExerciseDB {

    @objc(addWorkoutNameObject:)
    @NSManaged public func addToWorkoutName(_ value: WorkoutDB)

    @objc(removeWorkoutNameObject:)
    @NSManaged public func removeFromWorkoutName(_ value: WorkoutDB)

    @objc(addWorkoutName:)
    @NSManaged public func addToWorkoutName(_ values: NSSet)

    @objc(removeWorkoutName:)
    @NSManaged public func removeFromWorkoutName(_ values: NSSet)

}
