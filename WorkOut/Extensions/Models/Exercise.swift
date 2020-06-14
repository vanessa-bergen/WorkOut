//
//  Exercise.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation

class Exercise: Codable, Identifiable {
    let id = UUID()
    var name: String
    var description: String
}
