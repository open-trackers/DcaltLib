//
//  ZDayRun.swift
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
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       consumedDay: String, // "2022-02-03" format
                       calories: Int16 = 0,
                       createdAt: Date? = Date.now,
                       toStore: NSPersistentStore) -> ZDayRun
    {
        let nu = ZDayRun(context: context)
        nu.createdAt = createdAt
        nu.consumedDay = consumedDay
        nu.calories = calories
        context.assign(nu, to: toStore)
        return nu
    }
}

internal extension ZDayRun {
    static func getPredicate(consumedDay: String) -> NSPredicate {
        NSPredicate(format: "consumedDay == %@", consumedDay)
    }
}

public extension ZDayRun {
    var wrappedConsumedDay: String { consumedDay ?? "" }
}

public extension ZDayRun {
    /// Shallow copy of self to specified store, returning newly copied record (residing in dstStore).
    /// Does not delete self.
    /// Does NOT save context.
    internal func shallowCopy(_ context: NSManagedObjectContext,
                              toStore dstStore: NSPersistentStore) throws -> ZDayRun
    {
        guard let consumedDay
        else { throw TrackerError.missingData(msg: "consumedDay; can't copy") }
        return try ZDayRun.getOrCreate(context,
                                       consumedDay: consumedDay,
                                       inStore: dstStore) { _, element in
            element.calories = calories
            element.createdAt = createdAt
        }
    }

    static func get(_ context: NSManagedObjectContext,
                    consumedDay: String,
                    inStore: NSPersistentStore) throws -> ZDayRun?
    {
        let pred = getPredicate(consumedDay: consumedDay)
        return try context.firstFetcher(predicate: pred, inStore: inStore)
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

    // for use in user delete of individual routine runs in UI, from both stores
    static func delete(_ context: NSManagedObjectContext,
                       consumedDay: String,
                       inStore: NSPersistentStore? = nil) throws
    {
        let pred = getPredicate(consumedDay: consumedDay)

        try context.fetcher(predicate: pred, inStore: inStore) { (element: ZDayRun) in
            context.delete(element)
            return true
        }

        // NOTE: wasn't working due to conflict errors, possibly due to to cascading delete?
        // try context.deleter(ZDayRun.self, predicate: pred, inStore: inStore)
    }
}

public extension ZDayRun {
    var servingRunsArray: [ZServingRun] {
        (zServingRuns?.allObjects as? [ZServingRun]) ?? []
    }
}

public extension ZDayRun {
    /// NOTE: does NOT save context
    /// Respects the 'userRemoved' flag.
    func updateCalories() {
        guard let servingRuns = zServingRuns?.allObjects as? [ZServingRun] else { return }
        calories = servingRuns.filter { !$0.userRemoved }.reduce(0) { $0 + $1.calories }
    }
}
