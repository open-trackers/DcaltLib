
//
//  ZServingRun-encodable.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension ZServingRun: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case consumedTime
        case calories
        case userRemoved
        case createdAt
        case consumedDay // FK
        case servingArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(consumedTime, forKey: .consumedTime)
        try c.encode(calories, forKey: .calories)
        try c.encode(userRemoved, forKey: .userRemoved)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(zDayRun?.consumedDay, forKey: .consumedDay)
        try c.encode(zServing?.servingArchiveID, forKey: .servingArchiveID)
    }
}

extension ZServingRun: MAttributable {
    public static var fileNamePrefix: String {
        "zservingruns"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.consumedTime, .string),
        MAttribute(CodingKeys.calories, .int),
        MAttribute(CodingKeys.userRemoved, .bool),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.consumedDay, .string),
        MAttribute(CodingKeys.servingArchiveID, .string),
    ]
}
