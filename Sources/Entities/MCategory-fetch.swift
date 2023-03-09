
//
//  MCategory-fetch.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

internal extension MCategory {
    static func getPredicate(archiveID: UUID) -> NSPredicate {
        NSPredicate(format: "archiveID == %@", archiveID.uuidString)
    }
}

public extension MCategory {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \MCategory.createdAt, ascending: ascending),
        ]
    }

    /// sort by userOrder(ascending/descending), createdAt(ascending)
    static func byUserOrder(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \MCategory.userOrder, ascending: ascending),
            NSSortDescriptor(keyPath: \MCategory.createdAt, ascending: ascending),
        ]
    }
}

public extension MCategory {
    static func get(_ context: NSManagedObjectContext,
                    archiveID: UUID) throws -> MCategory?
    {
        let pred = getPredicate(archiveID: archiveID)
        let sort = byCreatedAt()
        return try context.firstFetcher(predicate: pred, sortDescriptors: sort)
    }

    /// Fetch a MCategory record, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            archiveID: UUID,
                            onUpdate: (Bool, MCategory) -> Void = { _, _ in }) throws -> MCategory
    {
        if let existing = try MCategory.get(context, archiveID: archiveID) {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = MCategory.create(context, archiveID: archiveID)
            onUpdate(false, nu)
            return nu
        }
    }
}
