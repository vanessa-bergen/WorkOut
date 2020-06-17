//
//  TimerView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import Combine

// need to add time break for in between rounds
struct TimerView: View {
    @Environment(\.presentationMode) var presentationMode
    var workout: Workout
    
    
    
    
    
    // used to track state of total workout
    @State private var workoutProgress: Float = 0.0
    @State private var workoutSeconds: Float = 0.0
    
    // used to track state of individual exercise
    @State private var exerciseProgress: Float = 0.0
    @State private var exerciseSeconds: Float = 0.0

    @State private var isActive = false
    @State private var firstRound = false
    
    @State private var onRest = false
    
    var controlButton: String {
        self.isActive ? "pause.fill" : "play.fill"
    }
    
    var timeRemaining: Float {
        if !onRest {
            return exerciseTime - exerciseSeconds
        } else {
            return breakTime - exerciseSeconds
        }
    }
    
    
    
    @State private var index = 0
    
    // time for individual exercise used in circular progress bar
    var exerciseTime: Float {
        Float(workout.exerciseList[self.index].time)
    }
    
    var breakTime: Float {
        Float(workout.exerciseList[self.index].restTime)
    }
    
    // time for total workout, used in line progress bar
    var totalWorkoutTime: Float {
        Float(workout.totalSeconds)
    }
    
    var percentComplete: Float {
        min(self.workoutSeconds / self.totalWorkoutTime * 100, 100)
    }
    
    //var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    //@ObservedObject var timer = TimerSetup()
    @State var timer: Timer.TimerPublisher = Timer.publish (every: 1, on: .main, in: .common)
    
    
    var body: some View {
        VStack {
            
           // Text("onrest: \(onRest ? "true" : "false"), index: \(index)")
            HStack {
                Text("\(percentComplete, specifier: "%.0f")%")
                ProgressBarView(value: self.$workoutProgress)
                    .frame(height: 30)
            }
            .padding(.top)
            Text("onrest: \(onRest ? "true" : "false"), index: \(index)")
            Spacer()
            Text(onRest ? "Rest" : self.workout.exerciseList[self.index].exercise.name)
                .font(.system(.largeTitle, design: .rounded))
                .bold()
                .padding()
            CircularProgressBar(value: self.$exerciseProgress, timeRemaining: self.timeRemaining, onRest: onRest)
                .padding()
                .frame(width: 230, height: 230)
            Spacer()
            
            // show whats up next in the last ten seconds
            
            if self.index + 1 < workout.exerciseList.count {
                VStack(alignment: .leading) {
                    Text("Up Next: ")
                        .font(.system(.headline, design: .rounded))
                    
                    Text(self.workout.exerciseList[index].restTime == 0 || onRest ? self.workout.exerciseList[index+1].exercise.name : "Rest")
                        .font(.system(.largeTitle, design: .rounded))
                }
                .isHidden(hidden: self.timeRemaining > 10, remove: false)
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
            print(self.timeRemaining)
            print("workout second \(self.workoutSeconds) increment \(self.workoutProgress)  percent \(self.percentComplete)")
            if self.workoutProgress >= 1.0 {
                print("stopping")
                self.timer.connect().cancel()
            }

            if self.exerciseProgress >= 1.0 {
            
                if self.index == self.workout.exerciseList.count - 1 {
                    print("index stop")
                    self.timer.connect().cancel()
                    self.isActive = false
                    
                } else {
                    if self.onRest {
                        // finished rest time, change to next exercise, set onRest to false
                        print("onRest \(self.onRest) increase index")
                        self.index += 1
                        self.onRest.toggle()
                    } else if !self.onRest && self.workout.exerciseList[self.index].restTime == 0 {
                        // no rest time, change to next exercise
                        self.index += 1
                    } else {
                        // finised the exercise, change to the rest time
                        self.onRest.toggle()
                    }
                }
                
                

                
                self.simpleSuccess()
                if self.isActive {
                self.exerciseProgress = 0
                self.exerciseSeconds = 0
                }
                //playSound(sound: "tone", type: "mp3")
                // change this to end when the workout time ends instead??
                

            } else {

                if self.firstRound && self.isActive {
                    self.exerciseSeconds += 1
                    
                }
            }
            if self.isActive {
            self.workoutSeconds += 1
            withAnimation(.linear(duration: 1)) {
                if !self.onRest {
                    self.exerciseProgress += 1 / self.exerciseTime
                } else {
                    self.exerciseProgress += 1 / self.breakTime
                }
                self.workoutProgress += 1 / self.totalWorkoutTime
            }
            self.firstRound = true
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
        .navigationBarTitle(Text(workout.name), displayMode: .inline)
        //.navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                self.isActive = false
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
            }
        )
        
        // prob need to use on dissapear if we navigate away from the screen, not sure yet
        .onDisappear {
            //self.timer.cleanup()
            self.timer.connect().cancel()
            
        }
        .onAppear {
            //self.timer.setup()
            self.timer = Timer.publish (every: 1, on: .main, in: .common)
            self.timer.connect()
            
        }
        
    }
    
    func simpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

//struct TimerView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    static var previews: some View {
//        TimerView(workout: <#T##Workout#>)
//    }
//}
