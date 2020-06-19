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
    
    
    var body: some View {
        GeometryReader { geo in
        VStack {
            
            Text("Select Workout To Add To Calender")
            DropDownView(selectedItem: self.$selectedWorkout, showingDropDown: self.$showingDropDown)
                .frame(height: self.showingDropDown ? geo.size.height/2 : geo.size.height/7)
                    //min(geo.size.height/5 * self.savedWorkouts.workouts.count, geo.size.height / 2) : geo.size.height/7)
                
                
            if self.accessGranted {
                Button(action: {
                    self.isShowing.toggle()
                }){
                    Text("add to calendar")
                }
            } else {
            
                Text("No access")
                Button(action: {
                    let openSettingsUrl = URL(string: UIApplication.openSettingsURLString)
                    UIApplication.shared.openURL(openSettingsUrl!)
                }){
                    Text("Go To Settings")
                }
            }
        }
        }
        .onAppear(perform: self.schedule)
        .sheet(isPresented: self.$isShowing) {
            EKEventWrapper(isShowing: self.$isShowing, workout: self.selectedWorkout)
        }
      
                
    }

    func schedule() {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        
        switch (status) {
        case EKAuthorizationStatus.notDetermined:
            requestAccessToCalendar()
        case EKAuthorizationStatus.authorized:
            accessGranted = true
            print("access already granted")
        case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
            // We need to help them give us permission
            //needPermissionView.fadeIn()
            print("not authorized")
        }
        
    }

    func requestAccessToCalendar() {
        eventStore.requestAccess(to: EKEntityType.event, completion: {
            (accessGranted: Bool, error: Error?) in
            
            if accessGranted == true {
                DispatchQueue.main.async(execute: {
                    self.accessGranted = true
                    print("access granted")
                })
            } else {
                DispatchQueue.main.async(execute: {

                    print("not granted add link to settings")
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
