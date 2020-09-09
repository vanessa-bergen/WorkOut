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
    static let voiceEnabledKey = "VoiceEnabled"
    static let voiceKey = "Voice"
    static let soundEnabledKey = "SoundEnabled"
    static let soundKey = "Sound"
    static let vibrationEnabledKey = "VibrationEnabled"
    static let workoutKey = "Workout"
    static let indexKey = "Index"

    public var sounds = ["Beep", "Bell", "Ding", "Electronic", "Pew", "Ping", "Tone"]
    
    public var accents = ["Australian" : "en-AU", "British" : "en-GB", "Canadian" : "en-ca", "Irish" : "en-ie", "South African" : "en-za", "Indian" : "en-in"]
    
    @Published var voiceEnabled: Bool {
        didSet {
            UserDefaults.standard.set(self.voiceEnabled, forKey: Self.voiceEnabledKey)
        }
    }
    
    @Published var voice: String {
        didSet {
            UserDefaults.standard.set(self.voice, forKey: Self.voiceKey)
        }
    }
    
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
    
    @Published var workout: Workout? {
        didSet {
            if let encoded = try? JSONEncoder().encode(self.workout) {
                UserDefaults.standard.set(encoded, forKey: Self.workoutKey)
            }
            //UserDefaults.standard.set(self.workout, forKey: Self.workoutKey)
        }
    }
    
    @Published var index: Int? {
        didSet {
            UserDefaults.standard.set(self.index, forKey: Self.indexKey)
        }
    }
    
    
    
    
    init() {
        // if no user data saved for enabled, default voice, sound and vibrate to true
        UserDefaults.standard.register(defaults: [Self.voiceEnabledKey: true])
        UserDefaults.standard.register(defaults: [Self.soundEnabledKey : true])
        UserDefaults.standard.register(defaults: [Self.vibrationEnabledKey : true])
        
        self.voiceEnabled = UserDefaults.standard.bool(forKey: Self.voiceEnabledKey)
        self.soundEnabled = UserDefaults.standard.bool(forKey: Self.soundEnabledKey)
        self.voice = UserDefaults.standard.string(forKey: Self.voiceKey) ?? "Canadian"
        self.sound = UserDefaults.standard.string(forKey: Self.soundKey) ?? "Beep"
        self.vibrationEnabled = UserDefaults.standard.bool(forKey: Self.vibrationEnabledKey)
        
        if let data = UserDefaults.standard.data(forKey: Self.workoutKey) {
            if let decoded = try? JSONDecoder().decode(Workout?.self, from: data) {
                self.workout = decoded
                return
            }
        } else {
            self.workout = nil
        }
        
        self.index = UserDefaults.standard.integer(forKey: Self.indexKey)
        
    }
    
}
