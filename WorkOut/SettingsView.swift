//
//  SettingsView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var userData = UserData()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Timer Sound")) {
                    Toggle(isOn: $userData.enabled) {
                        Text("Sound Enabled")
                    }
                    if userData.enabled {
                        List {
                            ForEach(userData.sounds, id: \.self) { sound in
                                SelectedCellView(item: sound, selectedItem: self.$userData.sound)
                            }
                        }
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
