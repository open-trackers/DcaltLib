
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

extension ZServingRun {
    internal static func dedupe(_ context: NSManagedObjectContext,
                                servingArchiveID: UUID,
                                consumedDay: String,
                                consumedTime: String,
                                inStore: NSPersistentStore) throws
    {
        let pred = getPredicate(servingArchiveID: servingArchiveID,
                                consumedDay: consumedDay,
                                consumedTime: consumedTime)
        let sort = byCreatedAt()
        var first: ZServingRun?
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZServingRun) in
            if first == nil {
                first = element
            } else {
                context.delete(element)
            }
            return true
        }
    }

    // NOTE: does NOT save context
    public static func dedupe(_ context: NSManagedObjectContext,
                              _ object: NSManagedObject,
                              inStore: NSPersistentStore) throws
    {
        guard let element = object as? ZServingRun
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun for de-duplication.")
        }

        guard let servingArchiveID = element.zServing?.servingArchiveID
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun.servingArchiveID for de-duplication.")
        }

        guard let consumedDay = element.zDayRun?.consumedDay
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun.consumedDay for de-duplication.")
        }

        guard let consumedTime = element.consumedTime
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun.consumedTime for de-duplication.")
        }

        try ZServingRun.dedupe(context,
                               servingArchiveID: servingArchiveID,
                               consumedDay: consumedDay,
                               consumedTime: consumedTime,
                               inStore: inStore)
    }
}
