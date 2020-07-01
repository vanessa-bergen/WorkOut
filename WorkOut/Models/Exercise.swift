//
//  Exercise.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

class Exercise: Codable, Identifiable, Equatable {
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: UUID
    var name: String
    var description: String
    
    init(name: String, description: String) {
        self.id = UUID()
        self.name = name
        self.description = description
    }
}
