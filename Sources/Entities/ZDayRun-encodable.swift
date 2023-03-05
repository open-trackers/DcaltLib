
//
//  ZDayRun.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
import CoreData

import TrackerLib

extension ZDayRun: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case consumedDay
        case calories
        case userRemoved
        case createdAt
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(consumedDay, forKey: .consumedDay)
        try c.encode(calories, forKey: .calories)
        try c.encode(userRemoved, forKey: .userRemoved)
        try c.encode(createdAt, forKey: .createdAt)
    }
}

extension ZDayRun: MAttributable {
    public static var fileNamePrefix: String {
        "zdayruns"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.consumedDay, .date),
        MAttribute(CodingKeys.calories, .int),
        MAttribute(CodingKeys.userRemoved, .bool),
        MAttribute(CodingKeys.createdAt, .date),
    ]
}
