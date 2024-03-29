//
//  MCategory.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

@objc(MCategory)
public class MCategory: NSManagedObject {}

public extension MCategory {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       name: String = "New Category",
                       userOrder: Int16 = 0,
                       lastCalories: Int16 = 0,
                       archiveID: UUID = UUID(),
                       createdAt: Date = Date.now) -> MCategory
    {
        let nu = MCategory(context: context)
        nu.createdAt = createdAt
        nu.name = name
        nu.userOrder = userOrder
        nu.lastCalories = lastCalories
        nu.archiveID = archiveID
        return nu
    }
}

public extension MCategory {
    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }

    var servingsArray: [MServing] {
        (servings?.allObjects as? [MServing]) ?? []
    }

    var foodGroupsArray: [MFoodGroup] {
        (foodGroups?.allObjects as? [MFoodGroup]) ?? []
    }

    var hasAtLeastOneServing: Bool {
        servings?.first != nil
    }
}

public extension MCategory {
    var filteredPresets: ServingPresetDict? {
        guard foodGroupsArray.count > 0 else { return nil }
        let foodGroups = foodGroupsArray.map { FoodGroup(rawValue: $0.groupRaw) }
        return servingPresets.filter { foodGroups.contains($0.key) }
    }
}
