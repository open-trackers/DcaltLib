//
//  WidgetEntry.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData
import Foundation
import WidgetKit

public struct WidgetEntry: TimelineEntry, Codable {
    public init(date: Date = Date.now,
                targetCalories: Int,
                currentCalories: Int)
    {
        self.date = date
        self.targetCalories = targetCalories
        self.currentCalories = currentCalories
    }

    public let date: Date
    public let targetCalories: Int
    public let currentCalories: Int
}


public extension UserDefaults {
    internal static let appGroupSuiteName = "group.org.openalloc.dcalt"
    internal static let widgetEntryKey = "widgetEntry"

    static let appGroup = UserDefaults(suiteName: appGroupSuiteName)!

    func getSimpleEntry() -> WidgetEntry? {
        guard let data = data(forKey: Self.widgetEntryKey) else { return nil }
        return try? JSONDecoder().decode(WidgetEntry.self, from: data)
    }

    func set(_ entry: WidgetEntry) {
        let data = try? JSONEncoder().encode(entry)
        set(data, forKey: Self.widgetEntryKey)
    }
}

public extension WidgetEntry {
    
    // Refresh widget with the latest data.
    // NOTE: does NOT save context (if AppSetting is created)
    static func refresh(_ context: NSManagedObjectContext, inStore: NSPersistentStore, now: Date = Date.now, reload: Bool) {
        guard let appSetting = try? AppSetting.getOrCreate(context) else { return }

        let calories: Int16 = {
            if let consumedDay = appSetting.subjectiveToday,
               let zdr = try? ZDayRun.get(context, consumedDay: consumedDay, inStore: inStore)
            {
                return zdr.refreshCalorieSum()
            } else {
                return 0
            }
        }()

        refresh(targetCalories: appSetting.targetCalories, currentCalories: calories, now: now, reload: reload)
    }

    static func refresh(targetCalories: Int16, currentCalories: Int16, now: Date = Date.now, reload: Bool) {
        print("REFRESH target \(targetCalories) current \(currentCalories)")
        let entry = WidgetEntry(date: now, targetCalories: Int(targetCalories), currentCalories: Int(currentCalories))
        UserDefaults.appGroup.set(entry)

        if reload {
            print("RELOADING ALL TIMELINES ##############################################")
            UserDefaults.appGroup.synchronize() // ensure new values written to disk
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

}
