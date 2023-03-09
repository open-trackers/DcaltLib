
//
//  ZServingRun-fetch.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

internal extension ZServingRun {
    /// NOTE does NOT filter for the userRemoved attribute!
    static func getPredicate(servingArchiveID: UUID,
                             consumedDay: String,
                             consumedTime: String) -> NSPredicate
    {
        NSPredicate(format: "zServing.servingArchiveID == %@ AND zDayRun.consumedDay == %@ AND consumedTime == %@",
                    servingArchiveID.uuidString,
                    consumedDay, consumedTime)
    }
}

public extension ZServingRun {
    static func byCreatedAt(ascending: Bool = true) -> [NSSortDescriptor] {
        [
            NSSortDescriptor(keyPath: \ZServingRun.createdAt, ascending: ascending),
        ]
    }
}

public extension ZServingRun {
    static func get(_ context: NSManagedObjectContext,
                    zServing: ZServing,
                    zDayRun: ZDayRun,
                    consumedTime: String,
                    inStore: NSPersistentStore) throws -> ZServingRun?
    {
        guard let servingArchiveID = zServing.servingArchiveID,
              let consumedDay = zDayRun.consumedDay else { return nil }
        return try get(context,
                       servingArchiveID: servingArchiveID,
                       consumedDay: consumedDay,
                       consumedTime: consumedTime,
                       inStore: inStore)
    }

    static func get(_ context: NSManagedObjectContext,
                    servingArchiveID: UUID,
                    zDayRun: ZDayRun,
                    consumedTime: String,
                    inStore: NSPersistentStore) throws -> ZServingRun?
    {
        guard let consumedDay = zDayRun.consumedDay else { return nil }
        return try get(context,
                       servingArchiveID: servingArchiveID,
                       consumedDay: consumedDay,
                       consumedTime: consumedTime,
                       inStore: inStore)
    }

    static func get(_ context: NSManagedObjectContext,
                    servingArchiveID: UUID,
                    consumedDay: String,
                    consumedTime: String,
                    inStore: NSPersistentStore) throws -> ZServingRun?
    {
        let pred = getPredicate(servingArchiveID: servingArchiveID,
                                consumedDay: consumedDay,
                                consumedTime: consumedTime)
        let sort = byCreatedAt()
        return try context.firstFetcher(predicate: pred, sortDescriptors: sort, inStore: inStore)
    }

    /// Fetch a ZServingRun record in the specified store, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            zDayRun: ZDayRun,
                            zServing: ZServing,
                            consumedTime: String,
                            inStore: NSPersistentStore,
                            onUpdate: (Bool, ZServingRun) -> Void = { _, _ in }) throws -> ZServingRun
    {
        if let existing = try ZServingRun.get(context,
                                              zServing: zServing,
                                              zDayRun: zDayRun,
                                              consumedTime: consumedTime,
                                              inStore: inStore)
        {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = ZServingRun.create(context,
                                        zDayRun: zDayRun,
                                        zServing: zServing,
                                        consumedTime: consumedTime,
                                        toStore: inStore)
            onUpdate(false, nu)
            return nu
        }
    }

    static func count(_ context: NSManagedObjectContext,
                      predicate: NSPredicate? = nil,
                      inStore: NSPersistentStore? = nil) throws -> Int
    {
        try context.counter(ZServingRun.self, predicate: predicate, inStore: inStore)
    }
}
