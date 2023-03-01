//
//  ZCategory.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

/// Archive representation of a Category record
public extension ZCategory {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       categoryArchiveID: UUID,
                       categoryName: String = "New Category",
                       createdAt: Date? = Date.now,
                       toStore: NSPersistentStore) -> ZCategory
    {
        let nu = ZCategory(context: context)
        nu.createdAt = createdAt
        nu.name = categoryName
        nu.categoryArchiveID = categoryArchiveID
        context.assign(nu, to: toStore)
        return nu
    }

    /// Shallow copy of self to specified store, returning newly copied record (residing in dstStore).
    /// Does not delete self.
    /// Does NOT save context.
    func shallowCopy(_ context: NSManagedObjectContext,
                     toStore dstStore: NSPersistentStore) throws -> ZCategory
    {
        guard let categoryArchiveID
        else { throw TrackerError.missingData(msg: "categoryArchiveID; can't copy") }
        return try ZCategory.getOrCreate(context,
                                         categoryArchiveID: categoryArchiveID,
                                         inStore: dstStore) { _, element in
            element.name = wrappedName
            element.createdAt = createdAt
        }
    }

    static func get(_ context: NSManagedObjectContext,
                    categoryArchiveID: UUID,
                    inStore: NSPersistentStore) throws -> ZCategory?
    {
        let pred = NSPredicate(format: "categoryArchiveID == %@", categoryArchiveID.uuidString)
        return try context.firstFetcher(predicate: pred, inStore: inStore)
    }

    /// Fetch a ZCategory record in the specified store, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            categoryArchiveID: UUID,
                            inStore: NSPersistentStore,
                            onUpdate: (Bool, ZCategory) -> Void = { _, _ in }) throws -> ZCategory
    {
        if let existing = try ZCategory.get(context,
                                            categoryArchiveID: categoryArchiveID,
                                            inStore: inStore)
        {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = ZCategory.create(context,
                                      categoryArchiveID: categoryArchiveID,
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

public extension ZCategory {
    var servingsArray: [ZServing] {
        (zServings?.allObjects as? [ZServing]) ?? []
    }
}

extension ZCategory {
    internal static func getPredicate(categoryArchiveID: UUID) -> NSPredicate {
        NSPredicate(format: "categoryArchiveID == %@", categoryArchiveID.uuidString)
    }

    internal static func dedupe(_ context: NSManagedObjectContext, categoryArchiveID: UUID, inStore: NSPersistentStore) throws {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID)
        let sort = [NSSortDescriptor(keyPath: \ZCategory.createdAt, ascending: true)]
        var first: ZCategory?
        try context.fetcher(predicate: pred, sortDescriptors: sort, inStore: inStore) { (element: ZCategory) in
            if let _first = first {
                for serving in element.servingsArray {
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

public extension ZCategory {
    // for use in user delete of individual routine runs in UI, from both stores
    static func delete(_ context: NSManagedObjectContext,
                       categoryArchiveID: UUID,
                       inStore: NSPersistentStore? = nil) throws
    {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID)

        try context.fetcher(predicate: pred, inStore: inStore) { (element: ZCategory) in
            context.delete(element)
            return true
        }

        // NOTE: wasn't working due to conflict errors, possibly due to to cascading delete?
        // try context.deleter(ZRoutineRun.self, predicate: pred, inStore: inStore)
    }

//    internal static func getPredicate(categoryArchiveID: UUID) -> NSPredicate {
//        NSPredicate(format: "zCategory.categoryArchiveID == %@",
//                    categoryArchiveID.uuidString)
//    }
}

extension ZCategory: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case name
        case createdAt
        case categoryArchiveID
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(name, forKey: .name)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(categoryArchiveID, forKey: .categoryArchiveID)
    }
}

extension ZCategory: MAttributable {
    public static var fileNamePrefix: String {
        "zcategories"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}

extension ZCategory {
    static func getCategories(for zDayRun: ZDayRun) -> [ZCategory] {
        let zServingRuns = ZServingRun.getServingRuns(for: zDayRun)

        let zServings = ZServing.getServings(for: zServingRuns)

        return zServings.compactMap(\.zCategory)
    }
}
