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
        lhs._id == rhs._id
    }
    
    enum CodingKeys: CodingKey {
        case name, description, _id
    }
    
    var _id: String
    var name: String
    var description: String
    
    init(name: String, description: String) {
        self._id = UUID().uuidString
        self.name = name
        self.description = description
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(_id, forKey: ._id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _id = try container.decode(String.self, forKey: ._id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""

    }
}
