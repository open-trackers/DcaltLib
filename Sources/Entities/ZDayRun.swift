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
    /// Shallow copy of self to specified store, returning newly copied record (residing in dstStore).
    /// Does not delete self.
    /// Does NOT save context.
    func shallowCopy(_ context: NSManagedObjectContext,
                     toStore dstStore: NSPersistentStore) throws -> ZDayRun
    {
        guard let consumedDay
        else { throw TrackerError.missingData(msg: "consumedDay; can't copy") }
        return try ZDayRun.getOrCreate(context,
                                       consumedDay: consumedDay,
                                       inStore: dstStore)
        { _, element in
            element.calories = calories
            element.createdAt = createdAt
            element.userRemoved = userRemoved
        }
    }
}

public extension ZDayRun {
    /// Like a delete, but allows the mirroring to archive and iCloud to properly
    /// reflect that the user 'deleted' the record(s) from the store(s).
    /// NOTE: does NOT save context.
    static func userRemove(_ context: NSManagedObjectContext,
                           consumedDay: String,
                           inStore: NSPersistentStore? = nil) throws
    {
        let pred = getPredicate(consumedDay: consumedDay)
        let sort = byCreatedAt()
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZDayRun) in
            element.userRemoved = true

            // cascade down to its serving runs
            try element.servingRunsArray.forEach {
                guard let servingArchiveID = $0.zServing?.servingArchiveID,
                      let consumedTime = $0.consumedTime
                else { return }

                try ZServingRun.userRemove(context, servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime)
            }

            return true
        }
    }
}

public extension ZDayRun {
    var wrappedConsumedDay: String { consumedDay ?? "" }

    var servingRunsArray: [ZServingRun] {
        (zServingRuns?.allObjects as? [ZServingRun]) ?? []
    }

    /// NOTE: does NOT save context
    /// Respects the 'userRemoved' flag.
    func updateCalories() {
        if userRemoved {
            calories = 0
            return
        }
        guard let servingRuns = zServingRuns?.allObjects as? [ZServingRun] else { return }
        calories = servingRuns.filter { !$0.userRemoved }.reduce(0) { $0 + $1.calories }
    }

    /// Generate a Date from yyyy-MM-dd and HH:mm:ss strings for a timezone.
    func consumedDate(consumedTime: String, tz: TimeZone = .current) -> Date? {
        guard let consumedDay else { return nil }
        return mergeDateLocal(dateStr: consumedDay, timeStr: consumedTime, tz: tz)
    }
}
