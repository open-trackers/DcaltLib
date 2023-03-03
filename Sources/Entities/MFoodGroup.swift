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
}

internal extension MFoodGroup {
    static func getPredicate(categoryArchiveID: UUID, groupRaw: Int16) -> NSPredicate {
        NSPredicate(format: "category.archiveID == %@ AND groupRaw == %i", categoryArchiveID.uuidString, groupRaw)
    }
}
