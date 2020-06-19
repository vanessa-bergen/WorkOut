//
//  SettingsView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import AudioToolbox

struct SettingsView: View {
    @ObservedObject var userData = UserData()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Timer Sound")) {
                    Toggle(isOn: $userData.soundEnabled) {
                        Text("Sound Enabled")
                    }
                    if userData.soundEnabled {
                        List {
                            ForEach(userData.sounds, id: \.self) { soundName in
                                SelectedCellView(item: soundName, selectedItem: self.$userData.sound)
                            }
                        }
                    }
                    
                }
                
                Section(header: Text("Vibration")) {
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
