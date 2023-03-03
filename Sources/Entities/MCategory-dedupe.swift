
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

extension MCategory {
    internal static func getPredicate(archiveID: UUID) -> NSPredicate {
        NSPredicate(format: "archiveID == %@", archiveID.uuidString)
    }

    internal static func dedupe(_ context: NSManagedObjectContext, archiveID: UUID) throws {
        let pred = getPredicate(archiveID: archiveID)
        let sort = [NSSortDescriptor(keyPath: \MCategory.createdAt, ascending: true)]
        var first: MCategory?
        try context.fetcher(predicate: pred, sortDescriptors: sort) { (element: MCategory) in
            if let _first = first {
                for serving in element.servingsArray {
                    element.removeFromServings(serving)
                    _first.addToServings(serving)
                }
                for foodGroup in element.foodGroupsArray {
                    element.removeFromFoodGroups(foodGroup)
                    _first.addToFoodGroups(foodGroup)
                }
                context.delete(element)
            } else {
                first = element
            }
            return true
        }
    }

    // NOTE: does NOT save context
    // NOTE: does NOT dedupe servings or foodGroups
    // Consolidates servings and foodGroups under the earliest dupe.
    public static func dedupe(_ context: NSManagedObjectContext, _ object: NSManagedObject) throws {
        guard let element = object as? MCategory,
              let archiveID = element.archiveID
        else { throw TrackerError.missingData(msg: "Could not resolve MCategory for de-duplication.") }

        try MCategory.dedupe(context, archiveID: archiveID)
    }
}
