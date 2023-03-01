//
//  ZTransferUtils.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData
import os

import TrackerLib

private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!,
                            category: "ZTransfer")

/// Transfers all 'Z' records in .main store to .archive store.
/// Safe to run on a background context.
///
/// Preserves all records in main store for the current (subjective) day.
/// This is to allow the history for the current day to be displayed on the watch.
/// (The watch doesn't have access to the archive store, by design.)
///
/// NOTE: does NOT save context
public func transferToArchive(_ context: NSManagedObjectContext,
                              mainStore: NSPersistentStore,
                              archiveStore: NSPersistentStore,
                              startOfDay: StartOfDay,
                              now: Date = Date.now,
                              tz: TimeZone = TimeZone.current) throws
{
    logger.debug("\(#function)")

    let (zCategories, zDayRuns) = try deepCopy(context,
                                               fromStore: mainStore,
                                               toStore: archiveStore)

    // get the "YYYY-MM-DD" for the current (subjective) day
    guard let (todayYYYYMMDD, _) = getSubjectiveDate(startOfDay: startOfDay.rawValue,
                                                     now: now,
                                                     tz: tz)
    else { throw TrackerError.missingData(msg: "Unable to determine subjective day for today.") }

    let todayZDayRun = zDayRuns.first(where: { $0.consumedDay == todayYYYYMMDD }) // okay if nil

    // Preserve today's zDayRun, if any.
    // Rely on cascading delete to remove zServingRun children
    let staleDayRuns = zDayRuns.filter { $0 != todayZDayRun }
    staleDayRuns.forEach { context.delete($0) }

    let freshCategories: [ZCategory] = {
        guard let todayZDayRun else { return [] }
        return ZCategory.getCategories(for: todayZDayRun)
    }()

    // delete stale zCategories (and zServings) from main store
    // (i.e., those upon which today's ZDayRun, if any, is not dependent.)
    // rely on cascading delete to remove children
    let staleCategories = zCategories.filter { !freshCategories.contains($0) }
    staleCategories.forEach { context.delete($0) }
}

/// Deep copy of all categories and their children from the source store to specified destination store
/// Returns list of ZCategories in fromStore that have been copied.
/// Does not delete any records.
/// Safe to run on a background context.
/// Does NOT save context.
internal func deepCopy(_ context: NSManagedObjectContext,
                       fromStore srcStore: NSPersistentStore,
                       toStore dstStore: NSPersistentStore) throws -> ([ZCategory], [ZDayRun])
{
    logger.debug("\(#function)")
    var copiedZCategories = [ZCategory]()
    var copiedZDays = [ZDayRun]()

    // Cache the dServings for creating dServingRun, where available.
    // NOTE zDayRun may refer to servings from multiple categories.
    var dServingDict: [UUID: ZServing] = [:]

    try context.fetcher(inStore: srcStore) { (sCategory: ZCategory) in

        let dCategory = try sCategory.shallowCopy(context, toStore: dstStore)

        let categoryPred = NSPredicate(format: "zCategory == %@", sCategory)

        try context.fetcher(predicate: categoryPred, inStore: srcStore) { (sServing: ZServing) in
            let dServing = try sServing.shallowCopy(context, dstCategory: dCategory, toStore: dstStore)

            if let uuid = dServing.servingArchiveID {
                dServingDict[uuid] = dServing
            } else {
                logger.debug("Missing archiveID for zServing \(sServing.wrappedName)")
            }

            logger.debug("Copied zServing \(sServing.wrappedName))")

            return true
        }

        copiedZCategories.append(sCategory)
        logger.debug("Copied zCategory \(sCategory.wrappedName)")
        return true
    }

    try context.fetcher(inStore: srcStore) { (sDayRun: ZDayRun) in

        let dDayRun = try sDayRun.shallowCopy(context, toStore: dstStore)

        // NOTE: including the userRemoved==1, as we need to reflect removed records in the archive
        // (which may have been previously copied as userRemoved=0)
        let dayRunPred = NSPredicate(format: "zDayRun == %@", sDayRun)

        try context.fetcher(predicate: dayRunPred, inStore: srcStore) { (sServingRun: ZServingRun) in

            guard let servingArchiveID = sServingRun.zServing?.servingArchiveID
            else {
                logger.debug("Could not determine servingArchiveID to obtain destination serving")
                return true
            }

            guard let dServing = dServingDict[servingArchiveID]
            else {
                logger.debug("Could not determine destination store serving for servingArchiveID; Cannot copy.")
                return true
            }

            _ = try sServingRun.shallowCopy(context, dstDayRun: dDayRun, dstServing: dServing, toStore: dstStore)

            logger.debug("Copied zServingRun \(sServingRun.zServing?.name ?? "") \(sServingRun.zDayRun?.consumedDay ?? "") \(sServingRun.consumedTime ?? "")")
            return true
        }

        copiedZDays.append(sDayRun)
        logger.debug("Copied zDayRun \(sDayRun.consumedDay ?? "")")
        return true
    }

    return (copiedZCategories, copiedZDays)
}
