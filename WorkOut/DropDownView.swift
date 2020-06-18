//
//  DropDownView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-17.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct DropDownView: View {
    @EnvironmentObject var savedWorkouts: Workouts
    @Binding var selectedItem: Workout?
    @Binding var showingDropDown: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 5) {
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        self.showingDropDown.toggle()
                    }
                }) {
                    HStack {
                        Text(self.selectedItem?.name ?? "Select One")
                        Spacer()
                        Text(self.selectedItem?.totalTime ?? "")
                        Spacer()
                        Image(systemName: self.showingDropDown ? "chevron.up" : "chevron.down")
                    }
                    .padding()
                }
                
                .frame(width: geo.size.width * 0.9)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                )
                if self.showingDropDown {
                ScrollView {
                    VStack(spacing: 0){
                        
                            ForEach(self.savedWorkouts.workouts) { workout in
                                VStack(alignment: .leading) {
                                    Text(workout.name)
                                        .font(.headline)
                                    Text(workout.totalTime)
                                        .font(.subheadline)
                                        
                                }
                                .padding()
                                // setting the height of each VStack in the scroll view
                                .frame(width: geo.size.width * 0.9, height: geo.size.height / 5, alignment: .leading)
                                .overlay(Rectangle().stroke(Color.darkTeal, lineWidth: 1))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    self.selectedItem = workout
                                }
                                    
                            }
                        }
                    }
                    //.frame(width: geo.size.width * 0.9, height: geo.size.height / 2.0)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.darkTeal.opacity(0.5), lineWidth: 2)
                    )
                    //.isHidden(hidden: self.showingDropDown, remove: true)
            }
                Spacer()
            }
        }
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView(selectedItem: .constant(nil), showingDropDown: .constant(true))
    }
}
