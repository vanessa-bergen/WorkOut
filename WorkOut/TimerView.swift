//
//  TimerView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

// need to add time break for in between rounds
struct TimerView: View {
    var workout: Workout
    
    // time for total workout, used in line progress bar
    var totalWorkoutTime: Float = 30.0
    
    // time for individual exercise used in circular progress bar
    var exerciseTime: Float = 15.0
    
    var breakTime: Float = 5.0
    
    // used to track state of total workout
    @State private var workoutProgress: Float = 0.0
    @State private var workoutSeconds: Float = 0.0
    
    // used to track state of individual exercise
    @State private var exerciseProgress: Float = 0.0
    @State private var exerciseSeconds: Float = 0.0

    @State private var isActive = false
    
    var controlButton: String {
        self.isActive ? "pause.fill" : "play.fill"
    }
    
    var timeRemaining: Float {
        exerciseTime - exerciseSeconds
    }
    
    var percentComplete: Float {
        min(self.workoutSeconds / self.totalWorkoutTime * 100, 100)
    }
    
    @State private var index = 0
    
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            
            HStack {
                Text("\(percentComplete, specifier: "%.0f")%")
                ProgressBarView(value: self.$workoutProgress)
                    .frame(height: 30)
            }
            .padding(.top)
            Spacer()
            Text(self.workout.exerciseArray[self.index].wrappedName)
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding()
            CircularProgressBar(value: self.$exerciseProgress, timeRemaining: self.timeRemaining)
                .padding()
                .frame(width: 230, height: 230)
            Spacer()
            
            // show whats up next in the last ten seconds
            
            if self.index + 1 < workout.exerciseArray.count {
                VStack(alignment: .leading) {
                    Text("Up Next: ")
                        .font(.system(.headline, design: .rounded))
                    
                    Text(self.workout.exerciseArray[index+1].wrappedName)
                        .font(.system(.largeTitle, design: .rounded))
                }
                .isHidden(self.timeRemaining > 10)
                .padding(.top)
            }
            

            
            //Text("\(self.seconds)")
            Button(action: {
                self.isActive.toggle()
            }){
                Image(systemName: controlButton)
                    .renderingMode(.original)
                    .font(.system(size: 60))
                    .padding()
            }
        }
        .padding()
        .onReceive(timer) { (time) in
            guard self.isActive else { return }
            print(time)
            if self.exerciseProgress >= 1.0 {
                
                self.exerciseProgress = 0
                self.exerciseSeconds = 0
                
                // change this to end when the workout time ends instead??
                if self.index + 1 >= self.workout.exerciseArray.count {
                    self.timer.upstream.connect().cancel()
                } else {
                    self.index += 1
                }
                
            }
            
            self.exerciseSeconds += 1
            self.workoutSeconds += 1
            withAnimation(.linear(duration: 1)) {
                self.exerciseProgress += 1 / self.exerciseTime
                self.workoutProgress += 1 / self.totalWorkoutTime
            }
            
        }
        // triggered when the app moves to the background
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        // triggered when the app enters the foreground
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.isActive = true
        }
        .navigationBarTitle("", displayMode: .inline)
        //.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        
        // prob need to use on dissapear if we navigate away from the screen, not sure yet
//        .onDisappear {
//            self.isActive = false
//        }
//        .onAppear {
//            self.isActive = true
//        }
        
    }
    
    
}

//struct TimerView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    static var previews: some View {
//        TimerView(workout: <#T##Workout#>)
//    }
//}
