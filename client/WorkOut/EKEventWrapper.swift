//
//  EKEventWrapper.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-17.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI
import EventKitUI

let eventStore = EKEventStore()

// wrapping a UIKit view controller inside a swiftui view
struct EKEventWrapper: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    var workout: Workout?
    var theEvent = EKEvent.init(eventStore: eventStore)
    
    func makeUIViewController(context: Context) -> EKEventEditViewController {
        

        let components = Calendar.current.dateComponents([.hour], from: Date())
        let curHour = components.hour ?? 11
        let startDate = Calendar.current.date(bySettingHour: (curHour+1) % 24, minute: 0, second: 0, of: Date()) ?? Date()
        theEvent.startDate = startDate
        let seconds = self.workout?.totalSeconds ?? 0
        // going to round up to the next minute
        // that way if the workout is 4 minutes 10 seconds, it will schedule 5 mins in the calendar
        theEvent.endDate = startDate.addingTimeInterval(TimeInterval(seconds + (60 - seconds % 60)))
        
        theEvent.title = self.workout?.name ?? "Workout"
        theEvent.calendar = eventStore.defaultCalendarForNewEvents
      
        
        let eventController = EKEventEditViewController()
        eventController.event = theEvent
        eventController.eventStore = eventStore
        eventController.editViewDelegate = context.coordinator
        return eventController
    }
    
    func updateUIViewController(_ uiViewController: EKEventEditViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = EKEventEditViewController
    
    class Coordinator: NSObject, UINavigationControllerDelegate, EKEventEditViewDelegate {
        
        var parent: EKEventWrapper
        init(_ parent: EKEventWrapper) {
            self.parent = parent
        }
        
        
        func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
            
            
             switch action {
                case .canceled:
                    print("Canceled")
                    parent.isShowing = false
                case .saved:
                    print("Saved")
                    do {
                        try controller.eventStore.save(controller.event!, span: .thisEvent, commit: true)
                    }
                    catch {
                        print("Problem saving event")
                    }
                    parent.isShowing = false
                case .deleted:
                    print("Deleted")
                    parent.isShowing = false
                @unknown default:
                    print("I shouldn't be here")
                    parent.isShowing = false
                }
            }

    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
}
