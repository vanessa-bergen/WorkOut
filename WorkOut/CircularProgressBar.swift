//
//  CircularProgressBar.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-08.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct CircularProgressBar: View {
   
    @Binding var value: Float
    //@Binding var timeRemaining: Float
    var timeRemaining: Float
    var onRest: Bool
    
    var progressColor: Color {
        if onRest {
            return .sunrise
        } else {
            return .darkTeal
        }
    }
    var body: some View {
        //GeometryReader { geometry in
            
            ZStack {
                Circle()
                    .stroke(lineWidth: 50)
                    .opacity(0.3)
                    .foregroundColor(self.progressColor)
                
                Circle()
                    // capping the trim at 100%
                    .trim(from: 0, to: CGFloat(min(self.value, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 50.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(self.progressColor)
                    // rotate the progress circle by 270 degrees in order for it to start at the top
                    .rotationEffect(Angle(degrees: 270.0))

                Text("\(self.timeRemaining, specifier: "%.0f")")
                    .font(.system(size: 60.0))
                    .bold()
 
            }
            
            //.frame(width: geometry.size.width, height: geometry.size.width)
        //}
    }
}

struct CircularProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressBar(value: .constant(0.4), timeRemaining: 10, onRest: false)
    }
}
