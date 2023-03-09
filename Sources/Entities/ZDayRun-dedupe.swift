
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

extension ZDayRun {
    internal static func dedupe(_ context: NSManagedObjectContext,
                                consumedDay: String,
                                inStore: NSPersistentStore) throws
    {
        let pred = getPredicate(consumedDay: consumedDay)
        let sort = byCreatedAt()
        var first: ZDayRun?
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZDayRun) in

            if let _first = first {
                for servingRun in element.servingRunsArray {
                    element.removeFromZServingRuns(servingRun)
                    _first.addToZServingRuns(servingRun)
                }
                context.delete(element)
            } else {
                first = element
            }
            return true
        }
    }

    // NOTE: does NOT save context
    // NOTE: does NOT dedupe zServingRuns
    // Consolidates zServingRuns under the earliest ZDayRun dupe.
    public static func dedupe(_ context: NSManagedObjectContext, _ object: NSManagedObject, inStore: NSPersistentStore) throws {
        guard let element = object as? ZDayRun,
              let consumedDay = element.consumedDay
        else { throw TrackerError.missingData(msg: "Could not resolve ZDayRun for de-duplication.") }

        try ZDayRun.dedupe(context, consumedDay: consumedDay, inStore: inStore)
    }
}
