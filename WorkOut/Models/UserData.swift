//
//  UserData.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation
import Combine
class UserData: ObservableObject {
    static let enabledKey = "SoundEnabled"
    static let soundKey = "Sound"
    
    //UserDefaults.standard.register(defaults: [Self.enabledKey : true])
    
    @Published var enabled: Bool {
        didSet {
            UserDefaults.standard.set(self.enabled, forKey: Self.enabledKey)
        }
    }
    @Published var sound: String {
        didSet {
            UserDefaults.standard.set(self.sound, forKey: Self.soundKey)
        }
    }
    
    public var sounds = ["Tone", "Beep", "Chime", "Ping"]
    
    init() {
        // if no user data saved for enabled, default it to true
        UserDefaults.standard.register(defaults: [Self.enabledKey : true])
        self.enabled = UserDefaults.standard.bool(forKey: Self.enabledKey)
        self.sound = UserDefaults.standard.string(forKey: Self.soundKey) ?? "Tone"
    }
    
}
