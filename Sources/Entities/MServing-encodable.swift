
//
//  MServing-encodable.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension MServing: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case archiveID
        case weight_g
        case calories
        case lastIntensity
        case name
        case volume_mL
        case userOrder
        case createdAt
        case categoryArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(archiveID, forKey: .archiveID)
        try c.encode(weight_g, forKey: .weight_g)
        try c.encode(calories, forKey: .calories)
        try c.encode(lastIntensity, forKey: .lastIntensity)
        try c.encode(name, forKey: .name)
        try c.encode(volume_mL, forKey: .volume_mL)
        try c.encode(userOrder, forKey: .userOrder)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(category?.archiveID, forKey: .categoryArchiveID)
    }
}

extension MServing: MAttributable {
    public static var fileNamePrefix: String {
        "servings"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.archiveID, .string),
        MAttribute(CodingKeys.weight_g, .double),
        MAttribute(CodingKeys.calories, .int),
        MAttribute(CodingKeys.lastIntensity, .double),
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.volume_mL, .double),
        MAttribute(CodingKeys.userOrder, .int),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}
