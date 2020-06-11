//
//  Exercise+CoreDataProperties.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-07.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var name: String?
    @NSManaged public var explanation: String?
    @NSManaged public var id: UUID?
    @NSManaged public var workoutName: NSSet?
    
    public var wrappedName: String {
        name ?? ""
    }

}

// MARK: Generated accessors for workoutName
extension Exercise {

    @objc(addWorkoutNameObject:)
    @NSManaged public func addToWorkoutName(_ value: Workout)

    @objc(removeWorkoutNameObject:)
    @NSManaged public func removeFromWorkoutName(_ value: Workout)

    @objc(addWorkoutName:)
    @NSManaged public func addToWorkoutName(_ values: NSSet)

    @objc(removeWorkoutName:)
    @NSManaged public func removeFromWorkoutName(_ values: NSSet)

}
