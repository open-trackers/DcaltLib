
//
//  MFoodGroup-encodable.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension MFoodGroup: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case groupRaw
        case userOrder
        case createdAt
        case categoryArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(groupRaw, forKey: .groupRaw)
        try c.encode(userOrder, forKey: .userOrder)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(category?.archiveID, forKey: .categoryArchiveID)
    }
}

extension MFoodGroup: MAttributable {
    public static var fileNamePrefix: String {
        "category-food-groups"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.groupRaw, .int),
        MAttribute(CodingKeys.userOrder, .int),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}
