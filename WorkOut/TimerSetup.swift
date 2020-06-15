//
//  TimerSetup.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-13.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

class TimerSetup: ObservableObject {
    @Published var seconds = 0
    private var subscriber: AnyCancellable?
   
    func setup() {
        self.seconds = 0
        self.subscriber = Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink(receiveValue: { time in
                print(time)
                
                self.seconds += 1
            })
    }

    func cleanup() {
        self.subscriber = nil
    }
}
