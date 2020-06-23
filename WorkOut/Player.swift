//
//  PlaySound.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import Foundation
import AVFoundation

class Player {
    var toneSoundEffect: AVAudioPlayer?
    let session = AVAudioSession.sharedInstance()
    let synthesizer = AVSpeechSynthesizer()
    
    init() {
        do {
            // Configure the audio session for playing recorded sounds
            // duckOthers means that the volume of other sources of audio playing will be reduced when this source plays
            try session.setCategory(AVAudioSession.Category.playback,
                                    mode: AVAudioSession.Mode.default,
                                    options: [AVAudioSession.CategoryOptions.duckOthers])
        } catch let error as NSError {
            print("Failed to set the audio session category and mode: \(error.localizedDescription)")
        }
    }
    
    func playVoice(word: String, accent: String) {
        let speech = AVSpeechUtterance(string: word)
        speech.voice = AVSpeechSynthesisVoice(language: accent)
        speech.rate = 0.4
        
        synthesizer.speak(speech)
        
    }

    func playSound(soundEnabled: Bool, sound: String, vibrationEnabled: Bool) {
        
        if vibrationEnabled {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        
        if let path = Bundle.main.path(forResource: sound, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)

            do {
                if soundEnabled {
                    toneSoundEffect = try AVAudioPlayer(contentsOf: url)
                    toneSoundEffect?.play()
                }
                
                
            } catch {
                print("Could not find and play the sound file.")
            }
        }
    }
}



