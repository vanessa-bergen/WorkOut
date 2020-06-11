//
//  PageView3.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-10.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct PageView3: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var currentPage: Int
    @Binding var chosenExercises: [Exercise]
    @Binding var exerciseTime: [Int]
    @Binding var breakTime: [Int]
    
    @State private var newWorkoutName = ""
    
    var totalTime: Int {
        let totalExerciseTime = (exerciseTime[0] * 60 + exerciseTime[2]) * chosenExercises.count
        let totalBreakTime = (breakTime[0] * 60 + breakTime[2]) * (chosenExercises.count - 1)
        return totalExerciseTime + totalBreakTime
    }
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Total time in seconds \(totalTime)")
                // what if it's an hour??
                Text("\(totalTime/60) m \(totalTime%60) s")
            }
            List {
                ForEach(chosenExercises, id: \.self) { exercise in
                    Text(exercise.wrappedName)
                }
                .onDelete(perform: onDelete)
                .onMove(perform: onMove)
            }
            HStack{
                TextField("Workout Name", text: self.$newWorkoutName)
                Button(action: {
                    let newWorkout = Workout(context: self.moc)
                    newWorkout.name = self.newWorkoutName
                    //let set = self.chosenExercises as NSSet
                    for excercise in self.chosenExercises {
                        newWorkout.addToExercises(excercise)
                    }
                    //newWorkout.addToExercises(set)
                    try? self.moc.save()
                    
                }) {
                    Text("Save workout")
                }
            }
            
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Done")
            }
            
            Spacer()
            HStack {
                PrevNavButton(currentPage: $currentPage)
                Spacer()
                
            }
        }
    .navigationBarItems(leading: EditButton())
    }
    
    private func onDelete(offsets: IndexSet) {
        chosenExercises.remove(atOffsets: offsets)
    }

    func onMove(source: IndexSet, destination: Int) {
        print("moving \(source) \(destination)")
        chosenExercises.move(fromOffsets: source, toOffset: destination)
    }
}

//struct PageView3_Previews: PreviewProvider {
//    static var previews: some View {
//        PageView3()
//    }
//}
