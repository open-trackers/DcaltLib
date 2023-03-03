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

@objc(MServing)
public class MServing: NSManagedObject {}

extension MServing: UserOrdered {}

public extension MServing {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       category: MCategory,
                       userOrder: Int16,
                       name: String = "New Serving",
                       archiveID: UUID = UUID(),
                       createdAt: Date = Date.now) -> MServing
    {
        let nu = MServing(context: context)
        category.addToServings(nu)
        nu.createdAt = createdAt
        nu.userOrder = userOrder
        nu.name = name
        nu.archiveID = archiveID
        return nu
    }

    var wrappedName: String {
        get { name ?? "unknown" }
        set { name = newValue }
    }
}

extension MServing {
    internal static func getPredicate(categoryArchiveID: UUID, servingArchiveID: UUID) -> NSPredicate {
        NSPredicate(format: "category.archiveID == %@ AND archiveID == %@", categoryArchiveID.uuidString, servingArchiveID.uuidString)
    }

    internal static func dedupe(_ context: NSManagedObjectContext, categoryArchiveID: UUID, servingArchiveID: UUID) throws {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID, servingArchiveID: servingArchiveID)
        let sort = [NSSortDescriptor(keyPath: \MServing.createdAt, ascending: true)]
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

public extension MServing {
    static func maxUserOrder(_ context: NSManagedObjectContext, category: MCategory) throws -> Int16? {
        var sort: [NSSortDescriptor] {
            [NSSortDescriptor(keyPath: \MServing.userOrder, ascending: false)]
        }
        let pred = NSPredicate(format: "category == %@", category)
        let serving: MServing? = try context.firstFetcher(predicate: pred, sortDescriptors: sort)
        return serving?.userOrder
    }
}

extension MServing: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case archiveID
        case weight_g
        case calories
        case lastIntensity
        case name
        case volume_mL
        case userOrder
        case createdAt
        case categoryArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(archiveID, forKey: .archiveID)
        try c.encode(weight_g, forKey: .weight_g)
        try c.encode(calories, forKey: .calories)
        try c.encode(lastIntensity, forKey: .lastIntensity)
        try c.encode(name, forKey: .name)
        try c.encode(volume_mL, forKey: .volume_mL)
        try c.encode(userOrder, forKey: .userOrder)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(category?.archiveID, forKey: .categoryArchiveID)
    }
}

extension MServing: MAttributable {
    public static var fileNamePrefix: String {
        "servings"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.archiveID, .string),
        MAttribute(CodingKeys.weight_g, .double),
        MAttribute(CodingKeys.calories, .int),
        MAttribute(CodingKeys.lastIntensity, .double),
        MAttribute(CodingKeys.name, .string),
        MAttribute(CodingKeys.volume_mL, .double),
        MAttribute(CodingKeys.userOrder, .int),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}
