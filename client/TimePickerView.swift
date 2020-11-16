//
//  TimePickerView.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-05.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

// UIPickerView is a view not a controller, so we use UIViewRepresentable instead of UIViewRepresentableController
struct TimePickerView: UIViewRepresentable {
    var data: [[String]]
    @Binding var selections: [Int]
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: TimePickerView

        //init(_:)
        init(_ timePickerView: TimePickerView) {
            self.parent = timePickerView
        }

        //numberOfComponents(in:)
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }

        //pickerView(_:numberOfRowsInComponent:)
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }

        //pickerView(_:titleForRow:forComponent:)
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.parent.data[component][row]
        }

        //pickerView(_:didSelectRow:inComponent:)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
            //self.parent.totalSeconds = self.parent.selections[0] * 60 + self.parent.selections[2]
        }
        
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            let w = pickerView.frame.size.width
            return component == 0 || component == 2 ? (1 / 8) * w : (2.5 / 8) * w
        }
        
        
    }
    
    func makeCoordinator() -> TimePickerView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TimePickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIView(_ uiView: UIPickerView, context: UIViewRepresentableContext<TimePickerView>) {
        for i in 0...(self.selections.count - 1) {
            uiView.selectRow(self.selections[i], inComponent: i, animated: false)
        }
    }
    
}
