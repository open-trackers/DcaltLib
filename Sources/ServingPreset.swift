//
//  ServingPreset.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation

import TextFieldPreset

import TrackerLib

public struct ServingPreset: PresettableItem, CustomStringConvertible {
    public var text: String
    public let volume_mL: Float? // in ml, if available
    public let weight_g: Float? // in grams, if available
    public let calories: Float

    public init(_ text: String,
                volume_mL: Float? = nil,
                weight_g: Float? = nil,
                calories: Float)
    {
        self.text = text
        self.volume_mL = volume_mL
        self.weight_g = weight_g
        self.calories = calories
    }

    public var description: String {
        "\(text) (\(calories) cal)"
    }
}
