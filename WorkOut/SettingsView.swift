//
//  SettingsView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import AVFoundation

struct SettingsView: View {
    @ObservedObject var userData = UserData()

    var body: some View {
        NavigationView {
            Form {
                
                Section(header: Text("Voice Upcoming Exercises")) {
                    Toggle(isOn: $userData.voiceEnabled) {
                        Text("Voice Enabled")
                    }
                    
                }
                if userData.voiceEnabled {
                    Section(header: Text("Configure Accent")) {
                        List {
                            ForEach(userData.accents.keys.sorted(), id: \.self) { accent in
                                SelectedCellView(item: accent, selectedItem: self.$userData.voice, alert: false, accents: self.userData.accents)
                            }
                        }
                    }
                }
                
                Section(header: Text("Alert When Timer Ends")) {
                    
                    Toggle(isOn: $userData.soundEnabled) {
                        Text("Alert Enabled")
                    }
                    if userData.soundEnabled {
                        
                        List {
                            ForEach(userData.sounds, id: \.self) { soundName in
                                SelectedCellView(item: soundName, selectedItem: self.$userData.sound, alert: true, accents: self.userData.accents)
                            }
                        }
                        
                    }
                    
                }
                
                Section(header: Text("Vibrate When Timer Ends")) {
                    Toggle(isOn: $userData.vibrationEnabled) {
                        Text("Vibration Enabled")
                    }
                }
                    
            }
            .navigationBarTitle("Settings")
        }
    }
}
    
    

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
