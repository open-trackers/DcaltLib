//
//  MCategory-userOrdered.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData

import TrackerLib

extension MCategory: UserOrdered {}

public extension MCategory {
    static func maxUserOrder(_ context: NSManagedObjectContext) throws -> Int16? {
        let sort = byUserOrder(ascending: false)
        let category: MCategory? = try context.firstFetcher(sortDescriptors: sort)
        return category?.userOrder
    }
}
