//
//  CreateWorkoutView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-23.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct CreateWorkoutView: View {
    @EnvironmentObject var savedWorkouts: Workouts
    
    @Binding var currentPage: Int
    @Binding var workout: Workout?
    
    @Binding var workoutName: String
    @Binding var description: String
    
    @State var warningMsgShown = false
    
    var warningMsg: String {
        if nameExists {
            return "A workout with this name already exists."
        } else {
            return "Please enter a name for the workout."
        }
    }
    
    var nameExists: Bool {
        // if we are editing an existing workout, we don't want to check this
        if workout != nil {
            return false
        }
        guard let _ = self.savedWorkouts.workouts.firstIndex(where: { $0.name == self.workoutName }) else {
            return false
        }
        return true
    }
    
    // show button as disabled if the workout name already exists or the workout name is empty
    var isDisabled: Bool {
        self.nameExists ? true : self.workoutName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                TextField("Workout Name", text: self.$workoutName)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .padding()
                    .frame(width: geo.size.width * 0.9, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                    )
                    .padding(.top)
                    
                Text(self.warningMsg)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .isHidden(hidden: !self.warningMsgShown, remove: true)
                    .padding([.leading, .trailing])
                
                UITextViewWrapper(text: self.$description)
                    .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.4, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                    )
                    
                Spacer()

                HStack {
                    Spacer()
                    
                    NextNavButton(currentPage: self.$currentPage, isDisabled: self.isDisabled)
                        .disabled(self.isDisabled)
                        .onTapGesture {
                            if self.isDisabled {
                                self.warningMsgShown = true
                            }
                        }
                }
                .onAppear {
                    guard let workout = self.workout else {
                        return
                    }
                    self.workoutName = workout.name
                    self.description = workout.description
                }

            }
        }
    }
}
