//
//  ZServing-fetch.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

internal extension ZServing {
    static func getPredicate(categoryArchiveID: UUID,
                             servingArchiveID: UUID) -> NSPredicate
    {
        NSPredicate(format: "zCategory.categoryArchiveID == %@ AND servingArchiveID == %@",
                    categoryArchiveID.uuidString,
                    servingArchiveID.uuidString)
    }
}

public extension ZServing {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \ZServing.createdAt, ascending: ascending),
        ]
    }
}

public extension ZServing {
    static func get(_ context: NSManagedObjectContext,
                    categoryArchiveID: UUID,
                    servingArchiveID: UUID,
                    inStore: NSPersistentStore) throws -> ZServing?
    {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID)
        let sort = byCreatedAt()
        return try context.firstFetcher(predicate: pred, sortDescriptors: sort, inStore: inStore)
    }

    static func get(_ context: NSManagedObjectContext,
                    zCategory: ZCategory,
                    servingArchiveID: UUID,
                    inStore: NSPersistentStore) throws -> ZServing?
    {
        guard let categoryArchiveID = zCategory.categoryArchiveID else { return nil }
        return try get(context, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: inStore)
    }

    /// Fetch a ZServing record in the specified store, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            zCategory: ZCategory,
                            servingArchiveID: UUID,
                            inStore: NSPersistentStore,
                            onUpdate: (Bool, ZServing) -> Void = { _, _ in }) throws -> ZServing
    {
        if let existing = try ZServing.get(context,
                                           zCategory: zCategory,
                                           servingArchiveID: servingArchiveID,
                                           inStore: inStore)
        {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = ZServing.create(context,
                                     zCategory: zCategory,
                                     servingArchiveID: servingArchiveID,
                                     toStore: inStore)
            onUpdate(false, nu)
            return nu
        }
    }
}
