//
//  Units.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation

public enum Units: Int16, CaseIterable {
    case none = 0
    case grams = 1
    case ounces = 2
    case milliliters = 3
    case fluidOunce = 4

    public var abbreviation: String {
        switch self {
        case .none:
            return ""
        case .grams:
            return "g"
        case .ounces:
            return "oz"
        case .milliliters:
            return "ml"
        case .fluidOunce:
            return "fl oz"
        }
    }

    public var description: String {
        switch self {
        case .none:
            return "none"
        case .grams:
            return "grams"
        case .ounces:
            return "ounces"
        case .milliliters:
            return "milliliters"
        case .fluidOunce:
            return "fluid ounces"
        }
    }

    public var formattedDescription: String {
        if abbreviation.count == 0 {
            return description.capitalized
        } else {
            return "\(description.capitalized) (\(abbreviation))"
        }
    }

    public static func from(_ rawValue: Int16) -> Units {
        Units(rawValue: rawValue) ?? .none
    }
}
