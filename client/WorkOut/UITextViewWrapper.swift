//
//  UITextViewWrapper.swift
//  WorkOut
//
//  Created by Vanessa Bergen on 2020-06-23.
//  Copyright © 2020 Vanessa Bergen. All rights reserved.
//

import SwiftUI

struct UITextViewWrapper: UIViewRepresentable {
    @Binding var text: String
    var placeholder = "Workout Description (Optional)"
    
    func makeUIView(context: Context) -> UITextView {
        
        let view = UITextView()
        view.delegate = context.coordinator
        
        view.isScrollEnabled = true
        view.isEditable = true
        view.isUserInteractionEnabled = true
        view.textAlignment = .center
        view.font = UIFont.preferredFont(forTextStyle: .title1)
        view.adjustsFontForContentSizeCategory = true
//        if text.isEmpty {
//            print("is empty")
//            view.text = placeholder
//            view.textColor = UIColor.placeholderText
//        }
//        print(text)
//        if text == placeholder {
//            view.textColor = UIColor.placeholderText
//
//        }
        
        return view
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if self.text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.placeholderText
        } else {
            uiView.text = text
            uiView.textColor = UIColor.black
        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: UITextViewWrapper
        
        init(_ parent: UITextViewWrapper) {
            self.parent = parent

        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = nil
            }
            textView.textColor = UIColor.black
        }
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.placeholderText
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            if textView.text != parent.placeholder {
                self.parent.text = textView.text
            }
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    
    
}

