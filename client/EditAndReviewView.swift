//
//  PageView3.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct EditAndReviewView: View {
    
    @EnvironmentObject var savedWorkouts: Workouts

    @Binding var currentPage: Int
    @Binding var workoutName: String
    @Binding var description: String
    @Binding var workout: Workout?
    @Binding var chosenExercises: [ExerciseSet]
    @Binding var exerciseTime: Int
    @Binding var breakTime: Int
    @Binding var selectedTab: Int
    @Binding var sheetPresented: Bool

    @State var editMode: Bool = false
    @State var warningMsgShown = false
    @State var showingPopup = false
    @State private var editExercise: ExerciseSet?
    
    var apiClient = APIClient()
    
    var totalSeconds: Int {
        calcTotalSeconds(exerciseSet: self.chosenExercises)
    }
    var timeString: String {
        totalTime(totalSeconds: totalSeconds)
    }
    
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(alignment: .leading) {
                   
                    VStack {
                        Text(self.workoutName)
                            .font(.title)
                        Text(self.description)
                            .font(.headline)
                            
                        Text("Total Time: \(self.timeString)")
                            .font(.headline)
                            
                    }
                    .padding()
                    .frame(width: geo.size.width * 0.9, alignment: .center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                    )
                    .padding()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            self.editMode.toggle()
                        }) {
                            if self.editMode {
                                Text("Done")
                                    .foregroundColor(.black)
                                    .padding([.top, .leading, .trailing])
                            } else {
                                Text("Reorder List")
                                    .foregroundColor(.black)
                                    .padding([.top, .leading, .trailing])
                            }
                        }
                    }
                    List {
                        ForEach(self.chosenExercises) { exercise in
                            HStack {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Text(exercise.exercise.name)
                                            .foregroundColor(.darkestTeal)
                                            .font(.headline)
                                        Text("\(exercise.time / 60):\(exercise.time % 60)")
                                            .timeStyle(rest: false)
                                    }
                                    HStack {
                                        
                                        if exercise.restTime > 0 {
                                            Text("Rest")
                                                .foregroundColor(.darkSunrise)
                                                .font(.subheadline)
                                            Text("\(exercise.restTime / 60):\(exercise.restTime % 60)")
                                                .timeStyle(rest: true)
                                        } else {
                                            Text("No Rest")
                                                .foregroundColor(.darkSunrise)
                                                .font(.subheadline)
                                        }
                                    }
                                }
                                Spacer()

                                Button(action: {
                                    self.editExercise = exercise
                                    self.showingPopup = true
                                }) {
                                    Image(systemName: "square.and.pencil")
                                }
                                .padding(.trailing)
                                Button(action: {

                                }) {
                                    Image(systemName: "trash")
                                }


                            }
                        }
                        .onMove(perform: self.onMove)

                    }
                    .environment(\.editMode, self.editMode ? .constant(.active) : .constant(.inactive))
                    
                    
                    
                    Button(action: {
                        guard let workout = self.workout else {
                            // create the new workout
                            let newWorkout = Workout(name: self.workoutName, description: self.description, exerciseList: self.chosenExercises)
                            //self.createWorkout(for: newWorkout)
                            self.apiClient.sendData(Workout.self, for: newWorkout, method: .post) { (result) in
                                switch result {
                                case .success((let data, let response)):
                                    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                                        print("no status code")
                                        return
                                    }
                                    if statusCode == 201 {
                                        do {
                                            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                            print("json return \(json)")
                                        } catch {
                                            print(error)
                                        }
                                        
                                        do {
                                            let decodedWorkout = try JSONDecoder().decode(Workout.self, from: data)
                                            print("created workout \(decodedWorkout._id) \(decodedWorkout.name)")
                                            self.savedWorkouts.add(decodedWorkout)
                                        
                                        } catch {
                                            print("Error: \(error)")
                                        }
                                    }
                                    
                                case .failure(let error):
                                    print(error)
                                }
                            }
                            
                            self.reset()
                            return
                        }
                        // to do, need to update workout here
                        // this way when we update the workout, it will force the saved workouts to refresh and changes will appear on the views
                        self.savedWorkouts.objectWillChange.send()
                        workout.name = self.workoutName
                        workout.description = self.description
                        workout.exerciseList = self.chosenExercises
                        
                        // update the workout on the server
                        self.apiClient.sendData(Workout.self, for: workout, method: .put) { (result) in
                            switch result {
                            case .success((let data, let response)):
                                guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                                    print("no status code")
                                    return
                                }
                                if statusCode == 200 {
                                    do {
                                        let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                                        print("json return for update workout \(json)")
                                    } catch {
                                        print("json serialization failed \(error)")
                                    }
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                        
                        self.reset()
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Save Workout")
                                .buttonStyle()
                            Spacer()
                        }
                    }
                    
                    
                    
                    Spacer()
                    HStack {
                        PrevNavButton(currentPage: self.$currentPage)
                        Spacer()
                        
                    }
                }
                .background(self.showingPopup ? Color.black.opacity(0.3) : Color.clear)
                    
                if self.showingPopup {
                    EditPopupView(showingPopup: self.$showingPopup, exerciseSet: self.$editExercise)
                        .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.8)
                        .background(RoundedRectangle(cornerRadius: 27).fill(Color.white.opacity(1)))
                        .overlay(RoundedRectangle(cornerRadius: 27).stroke(Color.black, lineWidth: 1))
                }
            }
            .onAppear {
                // set the list backgroun to clear, that way the background color can be set
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
            
        }
    }
    
    private func onDelete(offsets: IndexSet) {
        chosenExercises.remove(atOffsets: offsets)
    }

    func onMove(source: IndexSet, destination: Int) {
        chosenExercises.move(fromOffsets: source, toOffset: destination)
        // setting the new order
        for (index, item) in self.chosenExercises.enumerated() {
            item.order = index
        }
    }
    
    func reset() {
        self.workoutName = ""
        self.description = ""
        self.chosenExercises = []
        self.currentPage = 0
        // going back to the workout tab
        self.selectedTab = 0
        // closing the sheet view if this is opened for editing from the workout details view
        self.sheetPresented = false
        
    }
    
    
    func createWorkout(for workout: Workout) {
        
        guard let encoded = try? JSONEncoder().encode(workout) else {
            print("Failed to encode workout")
            return
        }
        
        let url = URL(string: "http://165.232.56.142:3004/workout2")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print("json return \(json)")
            } catch {
                print(error)
            }
            
            // if we get a success response, add the workout to savedWorkouts, that way we won't need to make another call to the server since we know it worked
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            print(statusCode ?? "no status")
            if statusCode == 201 {
                // do we need to have the right id here - may need to add the returned data?
                self.savedWorkouts.add(workout)
            }

        }.resume()
    }
    
    func updateWorkout(for workout: Workout) {
        
        guard let encoded = try? JSONEncoder().encode(workout) else {
            print("Failed to encode workout")
            return
        }
        
        let url = URL(string: "http://165.232.56.142:3004/workout/edit")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                print("json return \(json)")
            } catch {
                print(error)
            }
            
            // if we get a success response, add the workout to savedWorkouts, that way we won't need to make another call to the server since we know it worked
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            print(statusCode ?? "no status")
            if statusCode == 201 {
                
                // todo need to update the workout in the array
                // add error if it didnt work
                print(workout)
            }

        }.resume()
    }
}

