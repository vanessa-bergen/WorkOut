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
                            .foregroundColor(.white)
                            .font(.headline)
                        Spacer()
                        Text(self.selectedItem?.totalTime ?? "")
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: self.showingDropDown ? "chevron.up" : "chevron.down")
                            .imageScale(.large)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                
                .frame(width: geo.size.width * 0.9)
                .background(LinearGradient(gradient: Gradient(colors: [.darkestTeal, .darkTeal]), startPoint: .leading, endPoint: .trailing))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.white, lineWidth: 2)
                )
                .shadow(radius: 5)
                
                if self.showingDropDown {
                    ScrollView {
                        VStack(spacing: 0){
                            
                                ForEach(self.savedWorkouts.workouts) { workout in
                                    VStack(alignment: .leading) {
                                        Text(workout.name)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Text(workout.totalTime)
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            
                                    }
                                    .padding()
                                    // setting the height of each VStack in the scroll view
                                    .frame(width: geo.size.width * 0.9, alignment: .leading)
                                    .background(LinearGradient(gradient: Gradient(colors: [.darkestTeal, .darkTeal]), startPoint: .leading, endPoint: .trailing))
                                    .overlay(
                                        Rectangle()
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    .shadow(radius: 10)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        self.selectedItem = workout
                                        withAnimation {
                                            self.showingDropDown.toggle()
                                        }
                                    }
                                        
                                }
                            }
                        //.frame(width: geo.size.width * 0.9, height: geo.size.height / 2.0)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(Color.white, lineWidth: 2)
                        )
                        
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        
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
