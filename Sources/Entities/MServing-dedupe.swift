
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

extension MServing {
    internal static func dedupe(_ context: NSManagedObjectContext, categoryArchiveID: UUID, servingArchiveID: UUID) throws {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID)
        let sort = byCreatedAt()
        var first: MServing?
        try context.fetcher(predicate: pred, sortDescriptors: sort) { (element: MServing) in
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
        guard let element = object as? MServing,
              let categoryArchiveID = element.category?.archiveID,
              let servingArchiveID = element.archiveID
        else { throw TrackerError.missingData(msg: "Could not resolve MServing for de-duplication.") }

        try MServing.dedupe(context,
                            categoryArchiveID: categoryArchiveID,
                            servingArchiveID: servingArchiveID)
    }
}
