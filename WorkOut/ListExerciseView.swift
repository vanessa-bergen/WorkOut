//
//  ListExerciseView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-07-02.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct ListExerciseView: View {
    @EnvironmentObject var savedExercises: Exercises
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<self.savedExercises.exercises.count, id:  \.self) { index in
                    VStack(alignment: .leading) {
                        TextField("Exercise Name", text: self.$savedExercises.exercises[index].name)
                            .font(.headline)
                        TextField("Exercise Description", text: self.$savedExercises.exercises[index].description)
                            .font(.subheadline)

                    }

                }
                .onDelete(perform: self.onDelete)
            }
            .navigationBarTitle("Exercises")
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    func onDelete(at offsets: IndexSet) {
        self.savedExercises.delete(at: offsets)
    }
}

struct ListExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        ListExerciseView()
    }
}
