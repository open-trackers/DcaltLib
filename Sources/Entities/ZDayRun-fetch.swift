
//
//  ZDayRun-fetch.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

public extension ZDayRun {
    static func getPredicate(userRemoved: Bool) -> NSPredicate {
        NSPredicate(format: "userRemoved == %@", NSNumber(value: userRemoved))
    }

    static func getPredicate(consumedDay: String) -> NSPredicate {
        NSPredicate(format: "consumedDay == %@", consumedDay)
    }
}

public extension ZDayRun {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \ZDayRun.createdAt, ascending: ascending),
        ]
    }

    static func byConsumedDay(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \ZDayRun.consumedDay, ascending: ascending),
            NSSortDescriptor(keyPath: \ZDayRun.createdAt, ascending: true),
        ]
    }
}

public extension ZDayRun {
    static func get(_ context: NSManagedObjectContext,
                    consumedDay: String,
                    inStore: NSPersistentStore) throws -> ZDayRun?
    {
        let pred = getPredicate(consumedDay: consumedDay)
        let sort = byCreatedAt()
        return try context.firstFetcher(predicate: pred, sortDescriptors: sort, inStore: inStore)
    }

    /// Fetch a ZDayRun record in the specified store, creating if necessary.
    /// Will update calories on existing record.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            consumedDay: String,
                            inStore: NSPersistentStore,
                            onUpdate: (Bool, ZDayRun) -> Void = { _, _ in }) throws -> ZDayRun
    {
        if let existing = try ZDayRun.get(context, consumedDay: consumedDay, inStore: inStore) {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = ZDayRun.create(context,
                                    consumedDay: consumedDay,
                                    toStore: inStore)
            onUpdate(false, nu)
            return nu
        }
    }

    static func count(_ context: NSManagedObjectContext,
                      predicate: NSPredicate? = nil,
                      inStore: NSPersistentStore? = nil) throws -> Int
    {
        try context.counter(ZDayRun.self, predicate: predicate, inStore: inStore)
    }
}
