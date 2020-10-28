//
//  CustomTextField.swift
//  MovieHub
//
//  Created by Ronnie Arvanites on 10/16/20.
//

import Foundation
import UIKit
import SwiftUI

// SwiftUI wrapper for UIKit TextField
struct CustomTextField: UIViewRepresentable {

    @Binding var text: String
    @Binding var searchEditMode: Bool
    var isFirstResponder: Bool = false
    var keyboardType: UIKeyboardType
    var fontSize: CGFloat
    var placeholder: String
    let onSearchPressed: (() -> Void)
    let onTextChange: (() -> Void)

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField()
        // Makes width not extend pass parent
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        // Sets text color to black
        textField.textColor = UIColor.black
        // Makes text fit width
        textField.adjustsFontSizeToFitWidth = true
        // Sets the textfield's font size
        textField.font = UIFont.systemFont(ofSize: fontSize)
        // Sets the textfield's keyboard type
        textField.keyboardType = keyboardType
        // Sets the textfield's return key to search
        textField.returnKeyType = .search
        // Sets the textfield's placeholder
        textField.placeholder = placeholder
        // Sets the textfield's text cursor to black
        textField.tintColor = .black
        // Sets the textfield's clear button to only show while editing
        textField.clearButtonMode = .whileEditing
        
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, onSearchPressed: onSearchPressed, onTextChange: onTextChange, searchEditMode: $searchEditMode)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        // Set FirstResponder
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
        // Resign FirstResponder
        if !isFirstResponder && context.coordinator.didBecomeFirstResponder {
            uiView.resignFirstResponder()
            context.coordinator.didBecomeFirstResponder = false
        }
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var didBecomeFirstResponder = false
        let onSearchPressed: (() -> Void)
        let onTextChange: (() -> Void)
        @Binding var searchEditMode: Bool

        init(text: Binding<String>, onSearchPressed: @escaping (() -> Void), onTextChange: @escaping (() -> Void), searchEditMode: Binding<Bool>) {
            self._text = text
            self.onSearchPressed = onSearchPressed
            self.onTextChange = onTextChange
            self._searchEditMode = searchEditMode
        }

        // Called when text changes
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
            // Calls the onTextChange function
            if text != "" {
                self.onTextChange()
            }
        }
        
        // Called when search button is tapped on keyboard
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Resign FirstResponder
            textField.resignFirstResponder()
            // Call the onSearchPressed function
            self.onSearchPressed()
            return true;
        }

        // Called when editing has stopped
        func textFieldDidEndEditing(_ textField: UITextField) {
            // Resign FirstResponder
            textField.resignFirstResponder()
            // Sets searchEditMode to false
            self.searchEditMode = false
        }
        
        //Called when editing has begun
        func textFieldDidBeginEditing(_ textField: UITextField) {
            // Sets searchEditMode to true
            self.searchEditMode = true
        }
    }
}
