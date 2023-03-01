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
                       servingName: String = "New Serving",
                       createdAt: Date? = Date.now,
                       toStore: NSPersistentStore) -> ZServing
    {
        let nu = ZServing(context: context)
        zCategory.addToZServings(nu)
        nu.servingArchiveID = servingArchiveID
        nu.createdAt = createdAt
        nu.name = servingName
        // if let toStore {
        context.assign(nu, to: toStore)
        // }
        return nu
    }

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
                                          inStore: dstStore) { _, element in
            element.name = wrappedName
            element.createdAt = createdAt
        }
        return nu
    }

    static func get(_ context: NSManagedObjectContext,
                    categoryArchiveID: UUID,
                    servingArchiveID: UUID,
                    inStore: NSPersistentStore) throws -> ZServing?
    {
        let pred = NSPredicate(format: "zCategory.categoryArchiveID = %@ AND servingArchiveID == %@", categoryArchiveID.uuidString, servingArchiveID.uuidString)
        return try context.firstFetcher(predicate: pred, inStore: inStore)
    }

    static func get(_ context: NSManagedObjectContext,
                    zCategory: ZCategory,
                    servingArchiveID: UUID,
                    inStore: NSPersistentStore) throws -> ZServing?
    {
        let pred = NSPredicate(format: "zCategory == %@ AND servingArchiveID == %@", zCategory, servingArchiveID.uuidString)
        return try context.firstFetcher(predicate: pred, inStore: inStore)
    }

    /// Fetch a ZServing record in the specified store, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            zCategory: ZCategory,
                            servingArchiveID: UUID,
                            inStore: NSPersistentStore,
                            onUpdate: (Bool, ZServing) -> Void = { _, _ in }) throws -> ZServing
    {
        if let existing = try ZServing.get(context,
                                           zCategory: zCategory,
                                           servingArchiveID: servingArchiveID,
                                           inStore: inStore)
        {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = ZServing.create(context,
                                     zCategory: zCategory,
                                     servingArchiveID: servingArchiveID,
                                     toStore: inStore)
            onUpdate(false, nu)
            return nu
        }
    }

    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }
}

public extension ZServing {
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

extension ZServing: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case servingArchiveID
        case createdAt
        case categoryArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(servingArchiveID, forKey: .servingArchiveID)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(zCategory?.categoryArchiveID, forKey: .categoryArchiveID)
    }
}

extension ZServing: MAttributable {
    public static var fileNamePrefix: String {
        "zservings"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.servingArchiveID, .string),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}
