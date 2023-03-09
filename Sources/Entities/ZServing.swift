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

/// Archive representation of a Serving record
public extension ZServing {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       zCategory: ZCategory,
                       servingArchiveID: UUID,
                       servingName: String? = nil,
                       createdAt: Date? = Date.now,
                       toStore: NSPersistentStore) -> ZServing
    {
        let nu = ZServing(context: context)
        zCategory.addToZServings(nu)
        nu.servingArchiveID = servingArchiveID
        nu.createdAt = createdAt
        nu.name = servingName
        context.assign(nu, to: toStore)
        return nu
    }
}

public extension ZServing {
    /// Shallow copy of self to specified store, returning newly copied record (residing in dstStore).
    /// NOTE assumes that category is in dstStore.
    /// Does not delete self.
    /// Does NOT save context.
    func shallowCopy(_ context: NSManagedObjectContext,
                     dstCategory: ZCategory,
                     toStore dstStore: NSPersistentStore) throws -> ZServing
    {
        guard let servingArchiveID
        else { throw TrackerError.missingData(msg: "servingArchiveID; can't copy") }
        let nu = try ZServing.getOrCreate(context,
                                          zCategory: dstCategory,
                                          servingArchiveID: servingArchiveID,
                                          inStore: dstStore)
        { _, element in
            element.name = wrappedName
            element.createdAt = createdAt
        }
        return nu
    }
}

public extension ZServing {
    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }

    var servingRunsArray: [ZServingRun] {
        (zServingRuns?.allObjects as? [ZServingRun]) ?? []
    }

    static func getServings(for zServingRuns: [ZServingRun]) -> [ZServing] {
        let zServings: Set<ZServing> = zServingRuns.reduce(into: Set<ZServing>()) { set_, zServingRun in
            guard let zServing: ZServing = zServingRun.zServing else { return }
            set_.insert(zServing)
        }

        return Array(zServings)
    }
}
