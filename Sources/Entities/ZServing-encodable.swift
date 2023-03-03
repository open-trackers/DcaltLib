
//
//  ZServing.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension ZServing: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case servingArchiveID
        case createdAt
        case categoryArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(servingArchiveID, forKey: .servingArchiveID)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(zCategory?.categoryArchiveID, forKey: .categoryArchiveID)
    }
}

extension ZServing: MAttributable {
    public static var fileNamePrefix: String {
        "zservings"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.servingArchiveID, .string),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}
