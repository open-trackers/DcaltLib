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

    static func get(_ context: NSManagedObjectContext,
                    archiveID: UUID) throws -> MCategory?
    {
        let pred = getPredicate(archiveID: archiveID)
        return try context.firstFetcher(predicate: pred)
    }

    /// Fetch a MCategory record, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            archiveID: UUID,
                            onUpdate: (Bool, MCategory) -> Void = { _, _ in }) throws -> MCategory
    {
        if let existing = try MCategory.get(context, archiveID: archiveID) {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = MCategory.create(context, archiveID: archiveID)
            onUpdate(false, nu)
            return nu
        }
    }

    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }
}

public extension MCategory {
    var servingsArray: [MServing] {
        (servings?.allObjects as? [MServing]) ?? []
    }

    var foodGroupsArray: [MFoodGroup] {
        (foodGroups?.allObjects as? [MFoodGroup]) ?? []
    }
}

public extension MCategory {
    static var servingSort: [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \MServing.userOrder, ascending: true)]
    }

    var servingPredicate: NSPredicate {
        NSPredicate(format: "category == %@", self)
    }
}

public extension MCategory {
    var hasAtLeastOneServing: Bool {
        servings?.first != nil
    }
}
