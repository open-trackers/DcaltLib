//
//  ZServingRun.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

public extension ZServingRun {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       zDayRun: ZDayRun,
                       zServing: ZServing,
                       consumedTime: String,
                       calories: Int16 = 0,
                       createdAt: Date? = Date.now,
                       toStore: NSPersistentStore) -> ZServingRun
    {
        let nu = ZServingRun(context: context)
        zDayRun.addToZServingRuns(nu)
        zServing.addToZServingRuns(nu)
        nu.createdAt = createdAt
        nu.consumedTime = consumedTime
        nu.calories = calories
        context.assign(nu, to: toStore)
        return nu
    }
}

public extension ZServingRun {
    /// Shallow copy of self to specified store, returning newly copied record (residing in dstStore).
    /// Does not delete self.
    /// Does NOT save context.
    func shallowCopy(_ context: NSManagedObjectContext,
                     dstDayRun: ZDayRun,
                     dstServing: ZServing,
                     toStore dstStore: NSPersistentStore) throws -> ZServingRun
    {
        guard let consumedTime
        else { throw TrackerError.missingData(msg: "consumedTime not present; can't copy") }
        return try ZServingRun.getOrCreate(context,
                                           zDayRun: dstDayRun,
                                           zServing: dstServing,
                                           consumedTime: consumedTime,
                                           inStore: dstStore)
        { _, element in
            element.calories = calories
            element.createdAt = createdAt
            element.userRemoved = userRemoved
        }
    }
}

public extension ZServingRun {
    /// Like a delete, but allows the mirroring to archive and iCloud to properly
    /// reflect that the user 'deleted' the record(s) from the store(s).
    /// NOTE: does NOT save context.
    static func userRemove(_ context: NSManagedObjectContext,
                           servingArchiveID: UUID,
                           consumedDay: String,
                           consumedTime: String,
                           inStore: NSPersistentStore? = nil) throws
    {
        let pred = getPredicate(servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime)

        try context.fetcher(predicate: pred, inStore: inStore) { (element: ZServingRun) in
            element.userRemoved = true
            return true
        }
    }
}

public extension ZServingRun {
    var displayConsumedTime: String { String(consumedTime?.prefix(5) ?? "") }
}

extension ZServingRun {
    /// NOTE: does NOT filter for the userRemoved attribute.
    static func getServingRuns(for zDayRun: ZDayRun) -> [ZServingRun] {
        guard let zServingRuns = zDayRun.zServingRuns?.allObjects as? [ZServingRun] else { return [] }
        return zServingRuns
    }
}

public extension ZServingRun {
    static func sumCalories(_ elements: [ZServingRun]) -> Int16 {
        elements.filter { !$0.userRemoved }.reduce(0) { $0 + $1.calories }
    }
}
