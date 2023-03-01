//
//  ZServingRun.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

public extension ZServingRun {
//    var wrappedConsumedTime: String {
//        get { consumedTime ?? "" }
//        set { consumedTime = newValue }
//    }
    var displayConsumedTime: String { String(consumedTime?.prefix(5) ?? "") }
}

public extension ZServingRun {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       zDayRun: ZDayRun,
                       zServing: ZServing,
                       consumedTime: String,
                       calories: Int16 = 0,
                       createdAt: Date? = Date.now,
                       toStore: NSPersistentStore) -> ZServingRun
    {
        let nu = ZServingRun(context: context)
        zDayRun.addToZServingRuns(nu)
        zServing.addToZServingRuns(nu)
        nu.createdAt = createdAt
        nu.consumedTime = consumedTime
        nu.calories = calories
        context.assign(nu, to: toStore)
        return nu
    }

    /// Shallow copy of self to specified store, returning newly copied record (residing in dstStore).
    /// Does not delete self.
    /// Does NOT save context.
    func shallowCopy(_ context: NSManagedObjectContext,
                     dstDayRun: ZDayRun,
                     dstServing: ZServing,
                     toStore dstStore: NSPersistentStore) throws -> ZServingRun
    {
        guard let consumedTime
        else { throw TrackerError.missingData(msg: "consumedTime not present; can't copy") }
        return try ZServingRun.getOrCreate(context,
                                           zDayRun: dstDayRun,
                                           zServing: dstServing,
                                           consumedTime: consumedTime,
                                           inStore: dstStore) { _, element in
            element.calories = calories
            element.createdAt = createdAt
            element.userRemoved = userRemoved
        }
    }

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
        return try context.firstFetcher(predicate: pred, inStore: inStore)
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

    static func delete(_ context: NSManagedObjectContext,
                       servingArchiveID: UUID,
                       consumedAt: Date,
                       inStore: NSPersistentStore? = nil) throws
    {
        guard let (consumedDay, consumedTime) = splitDate(consumedAt)
        else { throw TrackerError.invalidData(msg: "consumedAt not valid") }
        return try delete(context,
                          servingArchiveID: servingArchiveID,
                          consumedDay: consumedDay,
                          consumedTime: consumedTime,
                          inStore: inStore)
    }

    // for use in user delete of individual serving runs in UI, potentially from both stores
    static func delete(_ context: NSManagedObjectContext,
                       servingArchiveID: UUID,
                       consumedDay: String,
                       consumedTime: String,
                       inStore: NSPersistentStore? = nil) throws
    {
        let pred = getPredicate(servingArchiveID: servingArchiveID, consumedDay: consumedDay, consumedTime: consumedTime)

        try context.fetcher(predicate: pred, inStore: inStore) { (element: ZServingRun) in
            context.delete(element)
            return true
        }

        // NOTE: wasn't working due to conflict errors, possibly due to to cascading delete?
        // try context.deleter(ZServingRun.self, predicate: pred, inStore: inStore)
    }
}

extension ZServingRun {
    /// NOTE does NOT filter for the userRemoved attribute!
    internal static func getPredicate(servingArchiveID: UUID,
                                      consumedDay: String,
                                      consumedTime: String) -> NSPredicate
    {
        NSPredicate(format: "zServing.servingArchiveID == %@ AND zDayRun.consumedDay == %@ AND consumedTime == %@",
                    servingArchiveID.uuidString,
                    consumedDay, consumedTime)
    }

    internal static func dedupe(_ context: NSManagedObjectContext,
                                servingArchiveID: UUID,
                                consumedDay: String,
                                consumedTime: String,
                                inStore: NSPersistentStore) throws
    {
        let pred = getPredicate(servingArchiveID: servingArchiveID,
                                consumedDay: consumedDay,
                                consumedTime: consumedTime)
        let sort = [NSSortDescriptor(keyPath: \ZServingRun.createdAt, ascending: true)]
        var first: ZServingRun?
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZServingRun) in
            if first == nil {
                first = element
            } else {
                context.delete(element)
            }
            return true
        }
    }

    // NOTE: does NOT save context
    public static func dedupe(_ context: NSManagedObjectContext,
                              _ object: NSManagedObject,
                              inStore: NSPersistentStore) throws
    {
        guard let element = object as? ZServingRun
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun for de-duplication.")
        }

        guard let servingArchiveID = element.zServing?.servingArchiveID
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun.servingArchiveID for de-duplication.")
        }

        guard let consumedDay = element.zDayRun?.consumedDay
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun.consumedDay for de-duplication.")
        }

        guard let consumedTime = element.consumedTime
        else {
            throw TrackerError.missingData(msg: "Could not resolve ZServingRun.consumedTime for de-duplication.")
        }

        try ZServingRun.dedupe(context,
                               servingArchiveID: servingArchiveID,
                               consumedDay: consumedDay,
                               consumedTime: consumedTime,
                               inStore: inStore)
    }
}

extension ZServingRun: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case consumedTime
        case calories
        case userRemoved
        case createdAt
        case consumedDay // FK
        case servingArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(consumedTime, forKey: .consumedTime)
        try c.encode(calories, forKey: .calories)
        try c.encode(userRemoved, forKey: .userRemoved)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(zDayRun?.consumedDay, forKey: .consumedDay)
        try c.encode(zServing?.servingArchiveID, forKey: .servingArchiveID)
    }
}

extension ZServingRun: MAttributable {
    public static var fileNamePrefix: String {
        "zservingruns"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.consumedTime, .string),
        MAttribute(CodingKeys.calories, .int),
        MAttribute(CodingKeys.userRemoved, .bool),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.consumedDay, .string),
        MAttribute(CodingKeys.servingArchiveID, .string),
    ]
}

extension ZServingRun {
    /// NOTE: does NOT filter for the userRemoved attribute.
    static func getServingRuns(for zDayRun: ZDayRun) -> [ZServingRun] {
        guard let zServingRuns = zDayRun.zServingRuns?.allObjects as? [ZServingRun] else { return [] }
        return zServingRuns
    }
}
