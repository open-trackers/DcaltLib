//
//  MCategory-standard.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import CoreData
import SwiftUI

// Standard categories stored with their own unique archiveID, to avoid
// duplication when user refreshes them.
enum StandardCategoryEnum: String, CaseIterable {
    case meat = "E94D0B63-0B8A-411D-879C-0D83682B4501"
    case seafood = "E94D0B63-0B8A-411D-879C-0D83682B4502"
    case entreeSide = "E94D0B63-0B8A-411D-879C-0D83682B4503"
    case dairy = "E94D0B63-0B8A-411D-879C-0D83682B4504"
    case breadGrain = "E94D0B63-0B8A-411D-879C-0D83682B4505"
    case fruitVeg = "E94D0B63-0B8A-411D-879C-0D83682B4506"
    case beverage = "E94D0B63-0B8A-411D-879C-0D83682B4507"
    case snack = "E94D0B63-0B8A-411D-879C-0D83682B4508"

    var name: String {
        switch self {
        case .meat:
            return "Meat"
        case .seafood:
            return "Seafood"
        case .entreeSide:
            return "Entree/Side"
        case .dairy:
            return "Dairy"
        case .breadGrain:
            return "Bread/Grain"
        case .fruitVeg:
            return "Fruit/Veg"
        case .beverage:
            return "Beverage"
        case .snack:
            return "Snack"
        }
    }

    var systemImage: String {
        switch self {
        case .meat:
            return "fork.knife"
        case .seafood:
            return "fish.fill"
        case .entreeSide:
            return "takeoutbag.and.cup.and.straw.fill"
        case .dairy:
            return "mug.fill"
        case .breadGrain:
            return "glowplug"
        case .fruitVeg:
            return "carrot.fill"
        case .beverage:
            return "cup.and.saucer.fill"
        case .snack:
            return "popcorn.fill"
        }
    }

    var foodGroups: [FoodGroup] {
        switch self {
        case .meat:
            return [.beef, .poultry, .pork]
        case .seafood:
            return [.fishSeafood]
        case .entreeSide:
            return [.mealsEntreesSides, .soupSauces, .condiments, .saladDressings]
        case .dairy:
            return [.dairy, .egg]
        case .breadGrain:
            return [.grainsPasta, .bakedGoods, .cereals, .legumes]
        case .fruitVeg:
            return [.vegetables, .fruit]
        case .beverage:
            return [.beverage]
        case .snack:
            return [.snacks, .nutsSeeds]
        }
    }

    var color: Color {
        switch self {
        case .meat:
            return .pink
        case .seafood:
            return .blue
        case .entreeSide:
            return .cyan
        case .dairy:
            return .gray
        case .breadGrain:
            return .yellow
        case .fruitVeg:
            return .green
        case .beverage:
            return .orange
        case .snack:
            return .mint
        }
    }
}

public extension MCategory {
    // NOTE: does NOT save context
    static func refreshStandard(_ context: NSManagedObjectContext) throws {
        var userOrder: Int16 = try MCategory.maxUserOrder(context) ?? 0

        for sc in StandardCategoryEnum.allCases {
            guard let archiveID = UUID(uuidString: sc.rawValue)
            else { continue }

            userOrder += 1

            let name = sc.name
            let category = try MCategory.getOrCreate(context, archiveID: archiveID) { _, element in
                element.name = name
                element.userOrder = userOrder
            }
            category.imageName = sc.systemImage
            category.setColor(sc.color)

            guard let foodGroupElems = category.foodGroups?.allObjects as? [MFoodGroup]
            else { continue }
            let foodGroups = foodGroupElems.map { FoodGroup(rawValue: $0.groupRaw) }
            var userOrder = foodGroupElems.max(by: { $0.userOrder < $1.userOrder })?.userOrder ?? 0
            for primary in sc.foodGroups {
                if foodGroups.contains(primary) { continue }
                userOrder += 1
                _ = MFoodGroup.create(context, category: category, userOrder: userOrder, groupRaw: primary.rawValue)
            }
        }
    }
}
