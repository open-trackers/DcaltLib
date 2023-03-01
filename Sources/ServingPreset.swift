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

import TrackerLib

public struct ServingPreset: NameablePreset & Hashable, CustomStringConvertible {
    public var title: String
    public let volume_mL: Float? // in ml, if available
    public let weight_g: Float? // in grams, if available
    public let calories: Float

    public init(title: String,
                volume_mL: Float? = nil,
                weight_g: Float? = nil,
                calories: Float)
    {
        self.title = title
        self.volume_mL = volume_mL
        self.weight_g = weight_g
        self.calories = calories
    }

    public var description: String {
        "\(title),\(volume_mL ?? -1),\(weight_g ?? -1),\(calories)"
        // "\(title),\(volume_mL),\(weight_g),\(calories)"
    }
}
