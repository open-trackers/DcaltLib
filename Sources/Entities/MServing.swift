//
//  MServing.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

@objc(MServing)
public class MServing: NSManagedObject {}

public extension MServing {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       category: MCategory,
                       userOrder: Int16,
                       name: String = "New Serving",
                       archiveID: UUID = UUID(),
                       createdAt: Date = Date.now) -> MServing
    {
        let nu = MServing(context: context)
        category.addToServings(nu)
        nu.createdAt = createdAt
        nu.userOrder = userOrder
        nu.name = name
        nu.archiveID = archiveID
        return nu
    }
}

public extension MServing {
    // Bulk creation of servings, from serving preset multi-select on iOS.
    // NOTE: does NOT save context
    static func bulkCreate(_ context: NSManagedObjectContext,
                           category: MCategory,
                           presets: [ServingPreset],
                           createdAt: Date = Date.now) throws
    {
        var userOrder = try (Self.maxUserOrder(context, category: category)) ?? 0
        presets.forEach { preset in
            userOrder += 1

            _ = MServing.create(context,
                                category: category,
                                userOrder: userOrder,
                                name: preset.text,
                                createdAt: createdAt)

            // try task.replaceFields(context, from: preset)
        }
    }
}

public extension MServing {
    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }

    var lastIntensityAt1: Bool {
        lastIntensity.isEqual(to: 1.0, accuracy: 0.01)
    }

    var netCalories: Int {
        guard lastIntensity > 0 else { return 0 }
        return Int(Float(calories) * lastIntensity)
    }
}
