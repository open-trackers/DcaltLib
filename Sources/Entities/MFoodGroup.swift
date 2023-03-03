//
//  MFoodGroup.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

@objc(MFoodGroup)
public class MFoodGroup: NSManagedObject {}

extension MFoodGroup: UserOrdered {}

public extension MFoodGroup {
    // NOTE: does NOT save context
    static func create(_ context: NSManagedObjectContext,
                       category: MCategory,
                       userOrder: Int16,
                       groupRaw: Int16,
                       createdAt: Date = Date.now) -> MFoodGroup
    {
        let nu = MFoodGroup(context: context)
        category.addToFoodGroups(nu)
        nu.createdAt = createdAt
        nu.userOrder = userOrder
        nu.groupRaw = groupRaw
        return nu
    }

//    var wrappedName: String {
//        get { name ?? "unknown" }
//        set { name = newValue }
//    }
}

extension MFoodGroup {
    internal static func getPredicate(categoryArchiveID: UUID, groupRaw: Int16) -> NSPredicate {
        NSPredicate(format: "category.archiveID == %@ AND groupRaw == %i", categoryArchiveID.uuidString, groupRaw)
    }

    internal static func dedupe(_ context: NSManagedObjectContext,
                                categoryArchiveID: UUID,
                                groupRaw: Int16) throws
    {
        let pred = getPredicate(categoryArchiveID: categoryArchiveID, groupRaw: groupRaw)
        let sort = [NSSortDescriptor(keyPath: \MFoodGroup.createdAt, ascending: true)]
        var first: MFoodGroup?
        try context.fetcher(predicate: pred, sortDescriptors: sort) { (element: MFoodGroup) in
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
        guard let element = object as? MFoodGroup,
              let archiveID = element.category?.archiveID
        else { throw TrackerError.missingData(msg: "Could not resolve MFoodGroup for de-duplication.") }

        try MFoodGroup.dedupe(context,
                              categoryArchiveID: archiveID,
                              groupRaw: element.groupRaw)
    }
}

extension MFoodGroup: Encodable {
    private enum CodingKeys: String, CodingKey, CaseIterable {
        case groupRaw
        case userOrder
        case createdAt
        case categoryArchiveID // FK
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(groupRaw, forKey: .groupRaw)
        try c.encode(userOrder, forKey: .userOrder)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(category?.archiveID, forKey: .categoryArchiveID)
    }
}

extension MFoodGroup: MAttributable {
    public static var fileNamePrefix: String {
        "category-food-groups"
    }

    public static var attributes: [MAttribute] = [
        MAttribute(CodingKeys.groupRaw, .int),
        MAttribute(CodingKeys.userOrder, .int),
        MAttribute(CodingKeys.createdAt, .date),
        MAttribute(CodingKeys.categoryArchiveID, .string),
    ]
}
