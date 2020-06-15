//
//  PlaySound.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation
import AVFoundation


var toneSoundEffect: AVAudioPlayer?


func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        let url = URL(fileURLWithPath: path)

        do {
            toneSoundEffect = try AVAudioPlayer(contentsOf: url)
            toneSoundEffect?.play()
        } catch {
            print("Could not find and play the sound file.")
        }
    }
}
