
//
//  ZServing.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension ZServing {
    /// NOTE does NOT filter for the userRemoved attribute!
    internal static func getPredicate(categoryArchiveID: UUID,
                                      servingArchiveID: UUID) -> NSPredicate
    {
        NSPredicate(format: "zCategory.categoryArchiveID == %@ AND servingArchiveID == %@",
                    categoryArchiveID.uuidString,
                    servingArchiveID.uuidString)
    }

    internal static func dedupe(_ context: NSManagedObjectContext,
                                categoryArchiveID: UUID,
                                servingArchiveID: UUID,
                                inStore: NSPersistentStore) throws
    {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID)
        let sort = [NSSortDescriptor(keyPath: \ZServing.createdAt, ascending: true)]
        var first: ZServing?
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZServing) in

            if let _first = first {
                for servingRun in element.servingRunsArray {
                    element.removeFromZServingRuns(servingRun)
                    _first.addToZServingRuns(servingRun)
                }
                context.delete(element)
            } else {
                first = element
            }
            return true
        }
    }

    // NOTE: does NOT save context
    // NOTE: does NOT dedupe zServingRuns
    // Consolidates zServingRuns under the earliest ZServing dupe.
    public static func dedupe(_ context: NSManagedObjectContext, _ object: NSManagedObject, inStore: NSPersistentStore) throws {
        guard let element = object as? ZServing,
              let categoryArchiveID = element.zCategory?.categoryArchiveID,
              let servingArchiveID = element.servingArchiveID
        else { throw TrackerError.missingData(msg: "Could not resolve ZServing for de-duplication.") }

        try ZServing.dedupe(context, categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID, inStore: inStore)
    }
}
