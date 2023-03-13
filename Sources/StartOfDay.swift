//
//  StartOfDay.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation

public enum StartOfDay: Int, CaseIterable, CustomStringConvertible {
    case _0000 = 0
    case _0100 = 3600
    case _0200 = 7200
    case _0300 = 10800 // default
    case _0400 = 14400
    case _0500 = 18000
    case _0600 = 21600
    case _0700 = 25200
    case _0800 = 28800
    case _0900 = 32400
    case _1000 = 36000
    case _1100 = 39600
    case _1200 = 43200
    case _1300 = 46800
    case _1400 = 50400
    case _1500 = 54000
    case _1600 = 57600
    case _1700 = 61200
    case _1800 = 64800
    case _1900 = 68400
    case _2000 = 72000
    case _2100 = 75600
    case _2200 = 79200
    case _2300 = 82800

    public static let defaultValue = StartOfDay._0300

    public var description: String {
        String(format: "%02d:%02d", hour, minute)
    }

    public var HH_mm_ss: String {
        "\(description):00"
    }

    public var hour: Int {
        Int(rawValue / 3600)
    }

    public var minute: Int {
        Int(rawValue % 60)
    }
}
