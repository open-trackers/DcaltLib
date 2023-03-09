
//
//  MFoodGroup.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension MFoodGroup {
    internal static func dedupe(_ context: NSManagedObjectContext,
                                categoryArchiveID: UUID,
                                groupRaw: Int16) throws
    {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID, groupRaw: groupRaw)
        let sort = byCreatedAt()
        var first: MFoodGroup?
        try context.fetcher(predicate: pred, sortDescriptors: sort) { (element: MFoodGroup) in
            if first == nil {
                first = element
            } else {
                context.delete(element)
            }
            return true
        }
    }

    // NOTE: does NOT save context
    // NOTE: does NOT dedupe categories
    public static func dedupe(_ context: NSManagedObjectContext, _ object: NSManagedObject) throws {
        guard let element = object as? MFoodGroup,
              let archiveID = element.category?.archiveID
        else { throw TrackerError.missingData(msg: "Could not resolve MFoodGroup for de-duplication.") }

        try MFoodGroup.dedupe(context,
                              categoryArchiveID: archiveID,
                              groupRaw: element.groupRaw)
    }
}
