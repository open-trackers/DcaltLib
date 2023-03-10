//
//  AppSetting.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

public let defaultTargetCalories: Int16 = 2000

public extension AppSetting {
    var startOfDayEnum: StartOfDay {
        get { StartOfDay(rawValue: Int(startOfDay)) ?? StartOfDay.defaultValue }
        set { startOfDay = Int32(newValue.rawValue) }
    }

    var subjectiveToday: String? {
        guard let sod = StartOfDay(rawValue: Int(startOfDay)),
              let (consumedDay, _) = Date.now.getSubjectiveDate(dayStartHour: sod.hour,
                                                                dayStartMinute: sod.minute)
        else { return nil }
        return consumedDay
    }
}

public extension AppSetting {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       targetCalories: Int16 = defaultTargetCalories,
                       startOfDay: StartOfDay = StartOfDay.defaultValue,
                       createdAt: Date = Date.now) -> AppSetting
    {
        let nu = AppSetting(context: context)
        nu.createdAt = createdAt
        nu.targetCalories = targetCalories
        nu.startOfDay = Int32(startOfDay.rawValue)
        return nu
    }
}
