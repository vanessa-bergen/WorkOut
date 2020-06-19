//
//  UserData.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-12.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation
import Combine
import AudioToolbox
class UserData: ObservableObject {
    static let soundEnabledKey = "SoundEnabled"
    static let soundKey = "Sound"
    static let vibrationEnabledKey = "VibrationEnabled"

    public var sounds = ["Beep", "Bell", "Ding", "Electronic", "Pew", "Ping", "Tone"]
    
    @Published var soundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(self.soundEnabled, forKey: Self.soundEnabledKey)
        }
    }
    @Published var sound: String {
        didSet {
            UserDefaults.standard.set(self.sound, forKey: Self.soundKey)
        }
    }
    
    @Published var vibrationEnabled: Bool {
        didSet {
            UserDefaults.standard.set(self.vibrationEnabled, forKey: Self.vibrationEnabledKey)
        }
    }
    
    
    
    
    init() {
        // if no user data saved for enabled, default it to true
        UserDefaults.standard.register(defaults: [Self.soundEnabledKey : true])
        UserDefaults.standard.register(defaults: [Self.vibrationEnabledKey : true])
        
        self.soundEnabled = UserDefaults.standard.bool(forKey: Self.soundEnabledKey)
        self.sound = UserDefaults.standard.string(forKey: Self.soundKey) ?? "Beep"
        self.vibrationEnabled = UserDefaults.standard.bool(forKey: Self.vibrationEnabledKey)
        
    }
    
}
