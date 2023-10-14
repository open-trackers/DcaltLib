
//
//  ZCategory-dedupe.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension ZCategory {
    static func dedupe(_ context: NSManagedObjectContext, categoryArchiveID: UUID, inStore: NSPersistentStore) throws {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID)
        let sort = byCreatedAt()
        var first: ZCategory?
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZCategory) in
            if let _first = first {
                for serving in element.zServingsArray {
                    element.removeFromZServings(serving)
                    _first.addToZServings(serving)
                }
                context.delete(element)
            } else {
                first = element
            }
            return true
        }
    }

    // NOTE: does NOT save context
    // NOTE: does NOT dedupe zServings
    // Consolidates zServings under the earliest ZCategory dupe.
    public static func dedupe(_ context: NSManagedObjectContext, _ object: NSManagedObject, inStore: NSPersistentStore) throws {
        guard let element = object as? ZCategory,
              let categoryArchiveID = element.categoryArchiveID
        else { throw TrackerError.missingData(msg: "Could not resolve ZCategory for de-duplication.") }

        try ZCategory.dedupe(context, categoryArchiveID: categoryArchiveID, inStore: inStore)
    }
}
