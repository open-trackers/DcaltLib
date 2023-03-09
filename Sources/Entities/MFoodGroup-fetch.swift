
//
//  MFoodGroup-fetch.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

internal extension MFoodGroup {
    static func getPredicate(categoryArchiveID: UUID, groupRaw: Int16) -> NSPredicate {
        NSPredicate(format: "category.archiveID == %@ AND groupRaw == %i", categoryArchiveID.uuidString, groupRaw)
    }
}

public extension MFoodGroup {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \MFoodGroup.createdAt, ascending: ascending),
        ]
    }
}
