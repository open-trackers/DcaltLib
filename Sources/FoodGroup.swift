//
//  FoodGroup.swift
//
// Copyright 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Foundation

// standard identifiers, to use for filtering presets to those relevant to a category
public enum FoodGroup: Int16, CaseIterable, CustomStringConvertible {
    case beef = 1
    case fruit = 2
    case snacks = 3
    case nutsSeeds = 4
    case condiments = 5
    case dairy = 6
    case beverage = 7
    case cereals = 8
    case fishSeafood = 9
    case pork = 10
    case poultry = 11
    case mealsEntreesSides = 12
    case legumes = 13
    case grainsPasta = 14
    case soupSauces = 15
    case vegetables = 16
    case bakedGoods = 17
    case saladDressings = 18
    case egg = 19

    public var description: String {
        switch self {
        case .beef:
            return "Beef"
        case .fruit:
            return "Fruit"
        case .snacks:
            return "Snacks"
        case .nutsSeeds:
            return "Nuts & Seeds"
        case .condiments:
            return "Condiments"
        case .dairy:
            return "Dairy"
        case .beverage:
            return "Beverage"
        case .cereals:
            return "Cereals"
        case .fishSeafood:
            return "Fish & Seafood"
        case .pork:
            return "Pork"
        case .poultry:
            return "Poultry"
        case .mealsEntreesSides:
            return "Meals, Entrees & Sides"
        case .legumes:
            return "Legumes"
        case .grainsPasta:
            return "Grains & Pasta"
        case .soupSauces:
            return "Soups & Sauces"
        case .vegetables:
            return "Vegetables"
        case .bakedGoods:
            return "Baked Goods"
        case .saladDressings:
            return "Salad Dressings"
        case .egg:
            return "Eggs"
        }
    }
}

extension FoodGroup: Comparable {
    public static func < (lhs: FoodGroup, rhs: FoodGroup) -> Bool {
        lhs.description < rhs.description
    }
}
