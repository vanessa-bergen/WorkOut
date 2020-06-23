//
//  SelectedCellView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct SelectedCellView: View {
    var audioPlayer = Player()
    
    let item: String
    @Binding var selectedItem: String
    var alert: Bool
    var accents: [String : String]

    var body: some View {
        HStack {
            Text(item)
            Spacer()
            if item == selectedItem {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        // making the whole row tappable
        .contentShape(Rectangle())
        .onTapGesture {
            
            self.selectedItem = self.item
            
            if self.alert {
                self.audioPlayer.playSound(soundEnabled: true, sound: self.selectedItem, vibrationEnabled: false)
            } else {
                self.audioPlayer.playVoice(word: "Hello, what a great time to workout!", accent: self.accents[self.item]!)
            }
            
        }
    }
}


