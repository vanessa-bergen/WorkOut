//
//  SettingsView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private let data: [[String]] = [
        Array(0...59).map { "\($0)" },
        ["Minutes"],
        Array(0...59).map { "\($0)" },
        ["Seconds"]
    ]

    @State private var exerciseSelections: [Int] = [5, 0, 10, 0]
    @State private var breakSelections: [Int] = [5, 0, 10, 0]
    
    @State private var soundEnabled = false
    var soundNames = ["Chime", "Ping"]
    @State private var selectedSound = "Chime"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Set Timers")) {
                    NavigationLink(destination: TimePickerView(data: data, selections: $exerciseSelections)) {
                        VStack(alignment: .leading) {
                            Text("Exercise Time")
                                .font(.headline)
                            Text("\(exerciseSelections[0]) minutes and \(exerciseSelections[2]) seconds")
                                .font(.subheadline)
                        }
                        
                    }
                    
                    NavigationLink(destination: TimePickerView(data: data, selections: $breakSelections)) {
                        VStack(alignment: .leading) {
                            Text("Break Time")
                                .font(.headline)
                            Text("\(breakSelections[0]) minutes and \(breakSelections[2]) seconds")
                                .font(.subheadline)
                        }
                        
                    }
                }
                    
                Section(header: Text("Sound")) {
                    Toggle(isOn: $soundEnabled.animation()) {
                        Text("Sound Enabled")
                    }
                    if soundEnabled {
                        List {
                            ForEach(soundNames, id: \.self) { sound in
                                SelectedCellView(item: sound, selectedItem: self.$selectedSound)
                            }
                        }
                    }
                    
                }
                    
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done") {
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
