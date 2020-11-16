//
//  ScheduleView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-17.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import EventKitUI

struct ScheduleView: View {
    @EnvironmentObject var savedWorkouts: Workouts
    @State private var selectedWorkout: Workout?
    @State private var showingDropDown = false
    @State private var isShowing = false
    @State private var accessGranted = false
    @State private var noAccess = false
    
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                
                Text("Select Workout To Add To Calender")
                DropDownView(selectedItem: self.$selectedWorkout, showingDropDown: self.$showingDropDown)
                    .frame(height: self.showingDropDown ? geo.size.height/2 : geo.size.height/7)
                        
                Button(action: {
                    self.isShowing.toggle()
                }){
                    Text("Add to calendar")
                        .buttonStyle()
                }
            }
        }
        .onAppear(perform: self.schedule)
        .sheet(isPresented: self.$isShowing) {
            EKEventWrapper(isShowing: self.$isShowing, workout: self.selectedWorkout)
        }
        .alert(isPresented: self.$noAccess) {
            Alert(
                title: Text("No Access To Calendar"),
                message: Text("Go to settings to allow access to calendar."),
                dismissButton: .default(Text("Ok")))
        }
      
                
    }

    func schedule() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            accessGranted = true
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            self.noAccess = true
        @unknown default:
            return
        }
        
    }

    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.accessGranted = true
                })
            } else {
                DispatchQueue.main.async(execute: {
                    self.accessGranted = false
                })
            }
        })
    }
}
struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
