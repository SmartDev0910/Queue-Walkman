//
//  CustomTextField.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import SwiftUI

struct CustomOutlinedTextField: TextFieldStyle {
        
        @State var icon: Image?
    @State var iconShowing: Bool = true
        
        func _body(configuration: TextField<Self._Label>) -> some View {
            HStack {
                if iconShowing {
                    if icon != nil {
                        icon
                            .foregroundColor(.primary)
                    }
                }
                configuration
            }
            .padding()
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.secondary, lineWidth: 1)
            }
            .foregroundColor(.primary)
        }
}

extension ToggleStyle where Self == CheckBoxToggleStyle {

    static var checkbox: CheckBoxToggleStyle {
        return CheckBoxToggleStyle()
    }
}

// Custom Toggle Style
struct CheckBoxToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Label {
                configuration.label
            } icon: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .accentColor : .secondary)
                    .accessibility(label: Text(configuration.isOn ? "Checked" : "Unchecked"))
                    .imageScale(.large)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
