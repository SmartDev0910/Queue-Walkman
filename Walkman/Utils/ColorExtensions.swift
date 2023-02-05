//
//  ColorExtensions.swift
//  Walkman
//
//  Created by Patrick Cockrill on 1/3/23.
//

import Foundation
import SwiftUI


extension Color {
    static let lightShadow = Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255)
    static let darkShadow = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    static let background = Color(red: 224 / 255, green: 229 / 255, blue: 236 / 255)
    static let neumorphictextColor = Color(red: 132 / 255, green: 132 / 255, blue: 132 / 255)
}

extension Float64 {
    func truncate(places : Int)-> Float64 {
            return Double(floor(pow(10.0, Float64(places)) * self)/pow(10.0, Float64(places)))
        }
}

