//
//  ZUtils.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

/// Delete ZDayRun and ZServingRun records older than keepSince
/// NOTE: does NOT save context
public func cleanLogRecords(_ context: NSManagedObjectContext, keepSinceDay: String, inStore: NSPersistentStore? = nil) throws {
    // ZServingRun should cascade delete off this

    let pred = NSPredicate(format: "consumedDay < %@", keepSinceDay)

    try context.fetcher(predicate: pred, inStore: inStore) { (element: ZDayRun) in
        context.delete(element)
        return true
    }

    // TODO: delete orphaned ZServing and ZCategory
}
