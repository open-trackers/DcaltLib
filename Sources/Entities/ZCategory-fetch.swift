//
//  ZCategory-fetch.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

internal extension ZCategory {
    static func getPredicate(categoryArchiveID: UUID) -> NSPredicate {
        NSPredicate(format: "categoryArchiveID == %@", categoryArchiveID.uuidString)
    }
}

public extension ZCategory {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \ZCategory.createdAt, ascending: ascending),
        ]
    }
}

public extension ZCategory {
    static func get(_ context: NSManagedObjectContext,
                    categoryArchiveID: UUID,
                    inStore: NSPersistentStore) throws -> ZCategory?
    {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID)
        let sort = byCreatedAt()
        return try context.firstFetcher(predicate: pred, sortDescriptors: sort, inStore: inStore)
    }

    /// Fetch a ZCategory record in the specified store, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            categoryArchiveID: UUID,
                            inStore: NSPersistentStore,
                            onUpdate: (Bool, ZCategory) -> Void = { _, _ in }) throws -> ZCategory
    {
        if let existing = try ZCategory.get(context,
                                            categoryArchiveID: categoryArchiveID,
                                            inStore: inStore)
        {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = ZCategory.create(context,
                                      categoryArchiveID: categoryArchiveID,
                                      toStore: inStore)
            onUpdate(false, nu)
            return nu
        }
    }
}
