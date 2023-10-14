
//
//  MCategory-encodable.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension MCategory: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case archiveID
        case imageName
        case name
        case color
        case userOrder
        case lastCalories
        case lastConsumedAt
        case createdAt
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(archiveID, forKey: .archiveID)
        try c.encode(imageName, forKey: .imageName)
        try c.encode(name, forKey: .name)
        try c.encode(color, forKey: .color)
        try c.encode(userOrder, forKey: .userOrder)
        try c.encode(lastCalories, forKey: .lastCalories)
        try c.encode(lastConsumedAt, forKey: .lastConsumedAt)
        try c.encode(createdAt, forKey: .createdAt)
    }
}

extension MCategory: MAttributable {
    public static var fileNamePrefix: String {
        "categories"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.archiveID, .string),
        MAttribute(CodingKeys.imageName, .string),
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.color, .data),
        MAttribute(CodingKeys.userOrder, .int),
        MAttribute(CodingKeys.lastCalories, .int),
        MAttribute(CodingKeys.lastConsumedAt, .date),
        MAttribute(CodingKeys.createdAt, .date),
    ]
}
