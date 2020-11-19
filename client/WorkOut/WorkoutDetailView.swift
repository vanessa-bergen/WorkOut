//
//  WorkoutDetailView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-11.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var savedWorkouts: Workouts
    @EnvironmentObject var savedExercises: Exercises
    
    @Binding var workout: Workout
    @Binding var selectedTab: Int
    
    @State private var showingDeleteAlert = false
    @State private var navigate = false
    @State private var selectTimerView = 0
    
    var apiClient = APIClient()
    
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .leading) {
                VStack {
                    Text(self.workout.name)
                        .font(.title)
                    Text(self.workout.description)
                        .font(.headline)
                    Text(self.workout.totalTime)
                        .font(.headline)
                }
                .padding()
                .frame(width: geo.size.width * 0.9, alignment: .center)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                )
                .padding()
                List {
                    ForEach(self.workout.exerciseList) { exercise in
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(exercise.exercise.name)
                                        .foregroundColor(.darkestTeal)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(exercise.time / 60):\(exercise.time % 60)")
                                        .timeStyle(rest: false)
                                }

                                if exercise.order != self.workout.exerciseList.count-1 {
                                    HStack {
                                        Text("Rest")
                                            .foregroundColor(.darkSunrise)
                                            .font(.subheadline)
                                        Spacer()
                                        if exercise.restTime > 0 {
                                            Text("\(exercise.restTime / 60):\(exercise.restTime % 60)")
                                                .timeStyle(rest: true)
                                        } else {
                                            Text("No Rest")
                                                .timeStyle(rest: true)
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                            }
                        }
                    }
                }
                HStack {
                    Spacer()
                    NavigationLink(destination: TimerView(workout: self.workout)) {

                        Text("Start Workout")
                            .buttonStyle()

                    }
                    .padding()
                    Spacer()
                }
            }
        }

        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(trailing:
            HStack(spacing: 20) {
                Button(action: {
                    self.navigate = true
                    
                }) {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }
                Button(action: {
                    self.showingDeleteAlert = true
                }) {
                    Image(systemName: "trash")
                        .imageScale(.large)
                }
            }
        )

        .alert(isPresented: $showingDeleteAlert) {
            Alert(title:
                Text("Warning!"),
                message: Text("Are you sure you want to delete?"),
                primaryButton: .destructive(Text("Delete")) {
                    self.deleteWorkout()
                },
                secondaryButton: .cancel())
        }
        .sheet(isPresented: $navigate) {
            CreateStepsView(workout: .constant(self.workout), selectedTab: self.$selectedTab, sheetPresented: self.$navigate)
                .environmentObject(self.savedWorkouts)
                .environmentObject(self.savedExercises)
                .accentColor(.turquiose)
        }
    }
    
    func deleteWorkout() {
        self.apiClient.sendData(Workout.self, for: self.workout, method: .delete) { (result) in
            switch result {
            case .success((let data, let response)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                    print("no status code")
                    return
                }
                if statusCode == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        print("json return for deleted workout \(json)")
                    } catch {
                        print("json serialization failed \(error)")
                    }
                    
                    self.savedWorkouts.delete(self.workout)
                }
                
            case .failure(let error):
                print(error)
            }
        }
        
        presentationMode.wrappedValue.dismiss()
    }
}
