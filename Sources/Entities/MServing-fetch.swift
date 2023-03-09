
//
//  MServing-fetch.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

public extension MServing {
    static func getPredicate(category: MCategory) -> NSPredicate {
        NSPredicate(format: "category == %@", category)
    }

    static func getPredicate(categoryArchiveID: UUID, servingArchiveID: UUID) -> NSPredicate {
        NSPredicate(format: "category.archiveID == %@ AND archiveID == %@", categoryArchiveID.uuidString, servingArchiveID.uuidString)
    }
}

public extension MServing {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \MServing.createdAt, ascending: ascending),
        ]
    }

    /// sort by userOrder(ascending/descending), createdAt(ascending)
    static func byUserOrder(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \MServing.userOrder, ascending: ascending),
            NSSortDescriptor(keyPath: \MServing.createdAt, ascending: ascending),
        ]
    }
}
