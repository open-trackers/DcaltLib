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

@objc(MCategory)
public class MCategory: NSManagedObject {}

extension MCategory: UserOrdered {}

public extension MCategory {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       name: String = "New Category",
                       userOrder: Int16 = 0,
                       lastCalories: Int16 = 0,
                       archiveID: UUID = UUID(),
                       createdAt: Date = Date.now) -> MCategory
    {
        let nu = MCategory(context: context)
        nu.createdAt = createdAt
        nu.name = name
        nu.userOrder = userOrder
        nu.lastCalories = lastCalories
        nu.archiveID = archiveID
        return nu
    }

    static func get(_ context: NSManagedObjectContext, forURIRepresentation url: URL) -> MCategory? {
        NSManagedObject.get(context, forURIRepresentation: url) as? MCategory
    }

    static func get(_ context: NSManagedObjectContext,
                    archiveID: UUID) throws -> MCategory?
    {
        let pred = getPredicate(archiveID: archiveID)
        return try context.firstFetcher(predicate: pred)
    }

    /// Fetch a MCategory record, creating if necessary.
    /// NOTE: does NOT save context
    static func getOrCreate(_ context: NSManagedObjectContext,
                            archiveID: UUID,
                            onUpdate: (Bool, MCategory) -> Void = { _, _ in }) throws -> MCategory
    {
        if let existing = try MCategory.get(context, archiveID: archiveID) {
            onUpdate(true, existing)
            return existing
        } else {
            let nu = MCategory.create(context, archiveID: archiveID)
            onUpdate(false, nu)
            return nu
        }
    }

    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }
}

public extension MCategory {
    var servingsArray: [MServing] {
        (servings?.allObjects as? [MServing]) ?? []
    }

    var foodGroupsArray: [MFoodGroup] {
        (foodGroups?.allObjects as? [MFoodGroup]) ?? []
    }
}

public extension MCategory {
    static func maxUserOrder(_ context: NSManagedObjectContext) throws -> Int16? {
        var sort: [NSSortDescriptor] {
            [NSSortDescriptor(keyPath: \MCategory.userOrder, ascending: false)]
        }
        let category: MCategory? = try context.firstFetcher(sortDescriptors: sort)
        return category?.userOrder
    }
}

public extension MCategory {
    static var servingSort: [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \MServing.userOrder, ascending: true)]
    }

    var servingPredicate: NSPredicate {
        NSPredicate(format: "category == %@", self)
    }
}

public extension MCategory {
    var hasAtLeastOneServing: Bool {
        servings?.first != nil
    }
}

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

extension MCategory: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case archiveID
        case imageName
        case name
        case color
        case userOrder
        case lastCalories
        case lastConsumedAt
        case createdAt
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(archiveID, forKey: .archiveID)
        try c.encode(imageName, forKey: .imageName)
        try c.encode(name, forKey: .name)
        try c.encode(color, forKey: .color)
        try c.encode(userOrder, forKey: .userOrder)
        try c.encode(lastCalories, forKey: .lastCalories)
        try c.encode(lastConsumedAt, forKey: .lastConsumedAt)
        try c.encode(createdAt, forKey: .createdAt)
    }
}

extension MCategory: MAttributable {
    public static var fileNamePrefix: String {
        "categories"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.archiveID, .string),
        MAttribute(CodingKeys.imageName, .string),
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.color, .data),
        MAttribute(CodingKeys.userOrder, .int),
        MAttribute(CodingKeys.lastCalories, .int),
        MAttribute(CodingKeys.lastConsumedAt, .date),
        MAttribute(CodingKeys.createdAt, .date),
    ]
}
