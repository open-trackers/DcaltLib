//
//  UserDefaults-ext.swift
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

typealias Key = UserDefaults.Keys

public extension UserDefaults {
    static let appGroupSuiteName = "group.org.openalloc.dcalt"

    static let appGroup = UserDefaults(suiteName: appGroupSuiteName)!

    enum Keys: String {
        case currentCalories
        case targetCalories
    }

//    func setArray(_ array: [some Encodable], forKey key: String) {
//        let data = try? JSONEncoder().encode(array)
//        set(data, forKey: key)
//    }
//
//    func getArray<Element>(forKey key: String) -> [Element]? where Element: Decodable {
//        guard let data = data(forKey: key) else { return nil }
//        return try? JSONDecoder().decode([Element].self, from: data)
//    }

    // ensure the widget/complication receives the updated value
    static func update(_ key: UserDefaults.Keys, value: Int) {
        let rawKey = key.rawValue
        UserDefaults.appGroup.set(value, forKey: rawKey)
    }
}

// Refresh widget with the latest data.
// NOTE: does NOT save context (if AppSetting is created)
public func refreshWidget(_ context: NSManagedObjectContext, inStore: NSPersistentStore) {
    guard let appSetting = try? AppSetting.getOrCreate(context) else { return }

    refreshWidget(targetCalories: appSetting.targetCalories)

    let calories: Int16 = {
        if let consumedDay = appSetting.subjectiveToday,
           let zdr = try? ZDayRun.get(context, consumedDay: consumedDay, inStore: inStore)
        {
            return zdr.refreshCalorieSum()
        } else {
            return 0
        }
    }()

    refreshWidget(currentCalories: calories)

    refreshWidgetReload()
}

public func refreshWidget(currentCalories: Int16) {
    print("REFRESH current \(currentCalories)")
    UserDefaults.update(.currentCalories, value: Int(currentCalories))
}

public func refreshWidget(targetCalories: Int16) {
    print("REFRESH target \(targetCalories)")
    UserDefaults.update(.targetCalories, value: Int(targetCalories))
}

public func refreshWidgetReload() {
    UserDefaults.appGroup.synchronize() // ensure new values written to disk
    WidgetCenter.shared.reloadAllTimelines()
    print("RELOADED ALL TIMELINES ##############################################")
}
