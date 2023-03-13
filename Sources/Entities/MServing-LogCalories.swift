//
//  MServing-LogCalories.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

// BUG: two quick adds of Breads/Grains of 150 within same minute only registers the first
// FIX: add seconds to consumedTime?

public extension MServing {
    // log for a specific serving at the specified intensity
    func logCalories(_ context: NSManagedObjectContext,
                     mainStore: NSPersistentStore,
                     intensity: Float = 1.0,
                     date: Date = Date.now,
                     tz: TimeZone = TimeZone.current) throws
    {
        guard let servingName = name,
              let servingArchiveID = archiveID,
              let category
        else {
            throw TrackerError.missingData(msg: "Unable to obtain prerequisites to log serving.")
        }

        guard let appSetting = try? AppSetting.getOrCreate(context) else {
            throw TrackerError.missingData(msg: "Unable to obtain app settings. Cannot create serving log.")
        }

        let netCalories = Int16(Float(calories) * intensity)

        try MServing.logCalories(context,
                                 category: category,
                                 mainStore: mainStore,
                                 servingArchiveID: servingArchiveID,
                                 servingName: servingName,
                                 netCalories: netCalories,
                                 startOfDay: appSetting.startOfDayEnum,
                                 date: date,
                                 tz: tz)

        lastIntensity = intensity
    }

    // Create a new ZServingRun record in mainStore reflecting the new calorie consumption.
    // NOTE: does NOT save context
    static func logCalories(_ context: NSManagedObjectContext,
                            category: MCategory,
                            mainStore: NSPersistentStore,
                            servingArchiveID: UUID,
                            servingName: String,
                            netCalories: Int16,
                            startOfDay: StartOfDay,
                            date: Date = Date.now,
                            tz: TimeZone = TimeZone.current) throws
    {
        guard let categoryArchiveID = category.archiveID,
              let categoryName = category.name
        else { throw TrackerError.missingData(msg: "Unable to log calories.") }

        let dayStartHour = startOfDay.hour
        let dayStartMinute = startOfDay.minute
        guard let (consumedDay, consumedTime) = date.getSubjectiveDate(dayStartHour: dayStartHour,
                                                                       dayStartMinute: dayStartMinute,
                                                                       tz: tz)
        else { throw TrackerError.invalidData(msg: "Unable to resolve subjective date to log calories.") }

        let zCategory = try ZCategory.getOrCreate(context,
                                                  categoryArchiveID: categoryArchiveID,
                                                  inStore: mainStore)
        { _, element in
            element.name = categoryName
        }

        let zServing = try ZServing.getOrCreate(context,
                                                zCategory: zCategory,
                                                servingArchiveID: servingArchiveID,
                                                inStore: mainStore)
        { _, element in
            element.name = servingName
        }

        let zDayRun = try ZDayRun.getOrCreate(context,
                                              consumedDay: consumedDay,
                                              inStore: mainStore)
        { _, element in
            element.calories = 0
            element.userRemoved = false // removal may have happened on another device; we're reversing it
        }

        _ = try ZServingRun.getOrCreate(context,
                                        zDayRun: zDayRun,
                                        zServing: zServing,
                                        consumedTime: consumedTime,
                                        inStore: mainStore)
        { _, element in
            element.calories = netCalories
        }

        // (re-)sum the day's total calories
        zDayRun.updateCalories()

        category.lastCalories = netCalories
        category.lastConsumedAt = date
    }
}
