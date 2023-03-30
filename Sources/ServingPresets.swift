//
//  ServingPresets.swift
//
// Copyright 2022, 2023  OpenAlloc LLC
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//

import Collections
import Foundation

import TrackerLib

public typealias ServingPresetDict = OrderedDictionary<FoodGroup, [ServingPreset]>

// see README for guidelines on adding/maintaining these presets.
public let servingPresets: ServingPresetDict = [
    .beef: [
        ServingPreset(title: "Beef Brisket (lean, braised)", weight_g: 100, calories: 221),
        ServingPreset(title: "Beef Composite (1/8” trimmed, cooked)", weight_g: 100, calories: 291),
        ServingPreset(title: "Beef Composite (lean, cooked)", weight_g: 100, calories: 212),
        ServingPreset(title: "Beef Rib (lean, braised, no bone)", weight_g: 100, calories: 228),
        ServingPreset(title: "Beef Rib Eye (trimmed of fat, broiled)", weight_g: 236, calories: 484),
        ServingPreset(title: "Beef Tenderloin (1/8” trimmed, broiled)", weight_g: 454, calories: 907),
        ServingPreset(title: "Beef Tenderloin (trimmed of fat, broiled)", weight_g: 87, calories: 168),
        ServingPreset(title: "Beef Top Sirloin (trimmed of fat, broiled)", weight_g: 292, calories: 534),
        ServingPreset(title: "Ground Beef Patty, 70/30 (broiled)", weight_g: 85, calories: 232),
        ServingPreset(title: "Ground Beef Patty, 70/30 (pan-broiled)", weight_g: 85, calories: 202),
        ServingPreset(title: "Ground Beef Patty, 75/25 (pan-broiled)", weight_g: 85, calories: 210),
        ServingPreset(title: "Ground Beef Patty, 80/20 (pan-broiled)", weight_g: 85, calories: 209),
        ServingPreset(title: "Ground Beef Patty, 85/15 (pan-broiled)", weight_g: 85, calories: 197),
        ServingPreset(title: "Ground Beef Patty, 90/10 (pan-broiled)", weight_g: 85, calories: 173),
        ServingPreset(title: "Ground Beef Patty, 95/5 (pan-broiled)", weight_g: 85, calories: 139),
        ServingPreset(title: "Pot Roast (lean, braised)", weight_g: 100, calories: 212),
    ],
    .fruit: [
        ServingPreset(title: "Apple (chopped)", volume_mL: 235.0, weight_g: 125, calories: 65),
        ServingPreset(title: "Apple", weight_g: 182, calories: 95),
        ServingPreset(title: "Avocado (pureed)", volume_mL: 235.0, weight_g: 230, calories: 384),
        ServingPreset(title: "Avocado (sliced)", volume_mL: 235.0, weight_g: 146, calories: 234),
        ServingPreset(title: "Banana (mashed)", volume_mL: 235.0, weight_g: 225, calories: 200),
        ServingPreset(title: "Banana", weight_g: 118, calories: 105),
        ServingPreset(title: "Blackberries", volume_mL: 235.0, weight_g: 144, calories: 62),
        ServingPreset(title: "Blueberries", volume_mL: 235.0, weight_g: 148, calories: 84),
        ServingPreset(title: "Cantaloupe (cubed)", volume_mL: 235.0, weight_g: 160, calories: 54),
        ServingPreset(title: "Grapefruit (sections)", volume_mL: 235.0, weight_g: 230, calories: 97),
        ServingPreset(title: "Grapes (seedless)", volume_mL: 235.0, weight_g: 151, calories: 104),
        ServingPreset(title: "Honeydew (diced)", volume_mL: 235.0, weight_g: 170, calories: 61),
        ServingPreset(title: "Kiwifruit", volume_mL: 235.0, weight_g: 186, calories: 112),
        ServingPreset(title: "Orange", weight_g: 131, calories: 62),
        ServingPreset(title: "Orange (sectioned)", volume_mL: 235.0, weight_g: 165, calories: 81),
        ServingPreset(title: "Peach", weight_g: 150, calories: 59),
        ServingPreset(title: "Peach (sliced)", volume_mL: 235.0, weight_g: 154, calories: 60),
        ServingPreset(title: "Pear", weight_g: 178, calories: 103),
        ServingPreset(title: "Pear (sliced)", volume_mL: 235.0, weight_g: 140, calories: 81),
        ServingPreset(title: "Pineapple (chunks)", volume_mL: 235.0, weight_g: 165, calories: 82),
        ServingPreset(title: "Plum", weight_g: 66, calories: 30),
        ServingPreset(title: "Plum (sliced)", volume_mL: 235.0, weight_g: 165, calories: 76),
        ServingPreset(title: "Raspberries", volume_mL: 235.0, weight_g: 123, calories: 64),
        ServingPreset(title: "Strawberries (sliced)", volume_mL: 235.0, weight_g: 166, calories: 53),
        ServingPreset(title: "Tangerine (sectioned)", volume_mL: 235.0, weight_g: 195, calories: 103),
        ServingPreset(title: "Watermelon (diced)", volume_mL: 235.0, weight_g: 152, calories: 46),
    ],
    .snacks: [
        ServingPreset(title: "Popcorn (air popped)", weight_g: 28, calories: 110),
        ServingPreset(title: "Potato Chips", weight_g: 100, calories: 542),
        ServingPreset(title: "Pretzels (hard)", weight_g: 60, calories: 229),
        ServingPreset(title: "Raisins", volume_mL: 60.0, weight_g: 40, calories: 120),
        ServingPreset(title: "Tortilla Chips, plain", weight_g: 100, calories: 490),
    ],
    .nutsSeeds: [
        ServingPreset(title: "Almonds (raw)", weight_g: 28, calories: 163),
        ServingPreset(title: "Almonds (roasted)", weight_g: 28, calories: 169),
        ServingPreset(title: "Cashews (roasted)", weight_g: 28, calories: 163),
        ServingPreset(title: "Peanuts (roasted)", weight_g: 28, calories: 165),
        ServingPreset(title: "Pecans (roasted)", weight_g: 28, calories: 200),
        ServingPreset(title: "Pistachio Nuts (roasted)", weight_g: 28, calories: 160),
        ServingPreset(title: "Sunflower Seeds", weight_g: 30, calories: 180),
    ],
    .condiments: [
        // TODO: mustard, mayonaise
        ServingPreset(title: "Catsup", weight_g: 15, calories: 15),
        ServingPreset(title: "Peanut Butter", volume_mL: 30.0, weight_g: 32, calories: 200),
        ServingPreset(title: "Salsa", volume_mL: 30.0, weight_g: 30, calories: 10),
        ServingPreset(title: "Sweet Pickle Relish", weight_g: 15, calories: 19),
    ],
    .dairy: [
        ServingPreset(title: "Blue Cheese", weight_g: 28, calories: 100),
        ServingPreset(title: "Brie Cheese", weight_g: 28, calories: 95),
        ServingPreset(title: "Butter", weight_g: 5, calories: 36),
        ServingPreset(title: "Butter (whipped)", weight_g: 4, calories: 27),
        ServingPreset(title: "Camembert Cheese", weight_g: 28, calories: 85),
        ServingPreset(title: "Cheddar Cheese", weight_g: 28, calories: 114),
        ServingPreset(title: "Cheese, low fat (cheddar or colby)", weight_g: 28, calories: 49),
        ServingPreset(title: "Cheese spread (cream cheese base)", weight_g: 28, calories: 84),
        ServingPreset(title: "Colby Cheese", weight_g: 28, calories: 112),
        ServingPreset(title: "Cottage Cheese, 1%", weight_g: 113, calories: 81),
        ServingPreset(title: "Cottage Cheese, 2%", weight_g: 113, calories: 97),
        ServingPreset(title: "Cottage Cheese", weight_g: 113, calories: 111),
        ServingPreset(title: "Cream Cheese, fat free", weight_g: 85, calories: 89),
        ServingPreset(title: "Cream Cheese", weight_g: 85, calories: 291),
        ServingPreset(title: "Feta Cheese", weight_g: 28, calories: 74),
        ServingPreset(title: "Fruit Yogurt, low fat", weight_g: 170, calories: 173),
        ServingPreset(title: "Fruit Yogurt, nonfat", weight_g: 170, calories: 161),
        ServingPreset(title: "Goat Cheese, hard", weight_g: 28, calories: 128),
        ServingPreset(title: "Goat Cheese, soft", weight_g: 28, calories: 76),
        ServingPreset(title: "Gouda Cheese", weight_g: 28, calories: 101),
        ServingPreset(title: "Gruyere Cheese", weight_g: 28, calories: 117),
        ServingPreset(title: "Half and Half", volume_mL: 30, calories: 39),
        ServingPreset(title: "Milk, 1%", volume_mL: 240.0, calories: 103),
        ServingPreset(title: "Milk, 2%", volume_mL: 240.0, calories: 122),
        ServingPreset(title: "Milk, skim or fat free", volume_mL: 240.0, calories: 86),
        ServingPreset(title: "Milk, whole", volume_mL: 240.0, calories: 150),
        ServingPreset(title: "Monterey Cheese", weight_g: 28, calories: 106),
        ServingPreset(title: "Mozzarella Cheese, part skim", weight_g: 28, calories: 72),
        ServingPreset(title: "Mozzarella Cheese, part skim, low moisture", weight_g: 28, calories: 85),
        ServingPreset(title: "Mozzarella Cheese, whole milk", weight_g: 28, calories: 85),
        ServingPreset(title: "Mozzarella Cheese, whole milk, low moisture", weight_g: 28, calories: 90),
        ServingPreset(title: "Mozzarella Cheese", weight_g: 28, calories: 78),
        ServingPreset(title: "Parmesan Cheese, reduced fat", weight_g: 5, calories: 13),
        ServingPreset(title: "Parmesan Cheese", weight_g: 5, calories: 22),
        ServingPreset(title: "Plain Yogurt, low fat", weight_g: 170, calories: 107),
        ServingPreset(title: "Plain Yogurt, skim milk", weight_g: 170, calories: 95),
        ServingPreset(title: "Plain Yogurt, whole milk", weight_g: 170, calories: 104),
        ServingPreset(title: "Provolone Cheese", weight_g: 28, calories: 100),
        ServingPreset(title: "Queso Anejo (cheese)", weight_g: 28, calories: 106),
        ServingPreset(title: "Queso Asadero (cheese)", weight_g: 28, calories: 101),
        ServingPreset(title: "Queso Chihuahua (cheese)", weight_g: 28, calories: 106),
        ServingPreset(title: "Ricotta Cheese, part skim milk", weight_g: 28, calories: 40),
        ServingPreset(title: "Ricotta Cheese, whole milk", weight_g: 28, calories: 49),
        ServingPreset(title: "Sour Cream, fat free", weight_g: 100, calories: 74),
        ServingPreset(title: "Sour Cream, light", weight_g: 100, calories: 138),
        ServingPreset(title: "Sour Cream, reduced fat", weight_g: 100, calories: 181),
        ServingPreset(title: "Swiss Cheese, reduced fat", weight_g: 28, calories: 49),
        ServingPreset(title: "Swiss Cheese", weight_g: 28, calories: 108),
        ServingPreset(title: "Table Cream", volume_mL: 30, calories: 59),
    ],
    .beverage: [
        ServingPreset(title: "Apple Juice, unsweetened", volume_mL: 240.0, calories: 112),
        ServingPreset(title: "Beer, light", volume_mL: 355, calories: 103),
        ServingPreset(title: "Beer", volume_mL: 355, calories: 153),
        ServingPreset(title: "Carbonated Soda, sweetened", volume_mL: 355, calories: 150),
        ServingPreset(title: "Dessert Wine, sweet", volume_mL: 104, calories: 165),
        ServingPreset(title: "Distilled Spirit, 100 proof", volume_mL: 44, calories: 124),
        ServingPreset(title: "Distilled Spirit, 80 proof", volume_mL: 44, calories: 97),
        ServingPreset(title: "Distilled Spirit, 86 proof", volume_mL: 44, calories: 105),
        ServingPreset(title: "Eggnog", volume_mL: 250, weight_g: 254, calories: 224),
        ServingPreset(title: "Grapefruit Juice, unsweetened", volume_mL: 240.0, weight_g: 247, calories: 96),
        ServingPreset(title: "Lemonade", volume_mL: 360.0, calories: 100),
        ServingPreset(title: "Orange Juice", volume_mL: 250.0, weight_g: 249, calories: 120),
        ServingPreset(title: "Pineapple Juice, unsweetened", volume_mL: 250.0, weight_g: 250, calories: 133),
        ServingPreset(title: "Pomegranate Juice", volume_mL: 250.0, weight_g: 250, calories: 135),
        ServingPreset(title: "Table Wine, light", volume_mL: 148, calories: 73),
        ServingPreset(title: "Table Wine", volume_mL: 148, calories: 123),
        ServingPreset(title: "Tangerine Juice", volume_mL: 250.0, weight_g: 247, calories: 106),
        ServingPreset(title: "Tonic Water", volume_mL: 355, calories: 125),
    ],
    .cereals: [
        ServingPreset(title: "Oats (w/water, cooked)", weight_g: 234, calories: 159),
    ],
    .fishSeafood: [
        ServingPreset(title: "Rainbow Trout, farmed (dry heat)", weight_g: 85, calories: 143),
        ServingPreset(title: "Rainbow Trout, wild (dry heat)", weight_g: 85, calories: 130),
        ServingPreset(title: "Salmon, Atlantic, farmed (dry heat)", weight_g: 85, calories: 175),
        ServingPreset(title: "Salmon, Atlantic, wild (dry heat)", weight_g: 85, calories: 154),
        ServingPreset(title: "Salmon, Chinook (dry heat)", weight_g: 85, calories: 196),
        ServingPreset(title: "Salmon, Chinook (smoked)", weight_g: 85, calories: 100),
        ServingPreset(title: "Snapper (dry heat)", weight_g: 85, calories: 109),
        ServingPreset(title: "Swordfish (dry heat)", weight_g: 85, calories: 146),
        ServingPreset(title: "Trout (dry heat)", weight_g: 85, calories: 162),
        ServingPreset(title: "Tuna, light (in water, drained)", weight_g: 85, calories: 98),
    ],
    .pork: [
        ServingPreset(title: "Bacon (microwaved)", weight_g: 15, calories: 76),
        ServingPreset(title: "Bacon (pan-fried)", weight_g: 24, calories: 126),
        ServingPreset(title: "Ham (lean, cooked)", weight_g: 100, calories: 122),
        ServingPreset(title: "Pork Loin (boneless, lean, broiled)", weight_g: 100, calories: 193),
        ServingPreset(title: "Pork Chop (broiled)", weight_g: 100, calories: 259),
    ],
    .poultry: [
        ServingPreset(title: "Chicken (fried, meat + skin)", weight_g: 100, calories: 331),
        ServingPreset(title: "Chicken (fried, meat only)", weight_g: 100, calories: 288),
        ServingPreset(title: "Chicken (roasted, meat + skin)", weight_g: 100, calories: 300),
        ServingPreset(title: "Chicken (roasted, meat only)", weight_g: 100, calories: 239),
        ServingPreset(title: "Chicken (rotisserie, meat + skin)", weight_g: 100, calories: 260),
        ServingPreset(title: "Chicken (rotisserie, meat only)", weight_g: 100, calories: 205),
        ServingPreset(title: "Chicken (stewed, meat only)", weight_g: 100, calories: 209),
        ServingPreset(title: "Chicken Breast (fried, meat + skin)", weight_g: 100, calories: 222),
        ServingPreset(title: "Chicken Breast (fried, meat only)", weight_g: 100, calories: 186),
        ServingPreset(title: "Chicken Breast (roasted, meat + skin)", weight_g: 100, calories: 197),
        ServingPreset(title: "Chicken Breast (roasted, meat only)", weight_g: 100, calories: 164),
        ServingPreset(title: "Chicken Breast (rotisserie, meat + skin)", weight_g: 100, calories: 184),
        ServingPreset(title: "Chicken Breast (rotisserie, meat only)", weight_g: 100, calories: 148),
        ServingPreset(title: "Chicken Breast (stewed, meat only)", weight_g: 100, calories: 151),
        ServingPreset(title: "Chicken Breast Tenders (microwaved)", weight_g: 100, calories: 252),
        ServingPreset(title: "Ground Turkey Patty (85/15, broiled)", weight_g: 100, calories: 249),
        ServingPreset(title: "Ground Turkey Patty (93/7, broiled)", weight_g: 100, calories: 207),
        ServingPreset(title: "Ground Turkey Patty (breaded, fried)", weight_g: 100, calories: 283),
        ServingPreset(title: "Ground Turkey Patty (fat-free, broiled)", weight_g: 100, calories: 138),
        ServingPreset(title: "Pate de foie gras (smoked)", weight_g: 28, calories: 131),
        ServingPreset(title: "Turkey (roasted, meat + skin)", weight_g: 100, calories: 244),
        ServingPreset(title: "Turkey (roasted, meat only)", weight_g: 100, calories: 170),
        ServingPreset(title: "Turkey Breast (roasted, meat only)", weight_g: 100, calories: 134),
    ],
    .mealsEntreesSides: [
        ServingPreset(title: "Breaded Chicken Sandwich with Cheese", weight_g: 228, calories: 631),
        ServingPreset(title: "French Fries", weight_g: 100, calories: 319),
        ServingPreset(title: "Grilled Chicken Sandwich", weight_g: 229, calories: 419),
        ServingPreset(title: "Cheeseburger (large, w/veg+cond)", weight_g: 233, calories: 480),
        ServingPreset(title: "Hamburger (large, w/veg+cond)", weight_g: 171, calories: 437),
        ServingPreset(title: "Pizza Slice, cheese only, thin crust", weight_g: 63, calories: 192),
        ServingPreset(title: "Pizza Slice, meat+veg, regular crust", weight_g: 136, calories: 331),
        ServingPreset(title: "Sausage Biscuit with Egg", weight_g: 117, calories: 440),
    ],
    .legumes: [
        ServingPreset(title: "Baked Beans", volume_mL: 235.0, weight_g: 253, calories: 266),
        ServingPreset(title: "Black Beans (cooked)", volume_mL: 235.0, weight_g: 172, calories: 227),
        ServingPreset(title: "Chickpeas (cooked)", volume_mL: 235.0, weight_g: 164, calories: 269),
        ServingPreset(title: "Fava Beans (cooked)", volume_mL: 235.0, weight_g: 170, calories: 187),
        ServingPreset(title: "Great Northern Beans (cooked)", volume_mL: 235.0, weight_g: 177, calories: 209),
        ServingPreset(title: "Hummus", volume_mL: 235.0, weight_g: 246, calories: 408),
        ServingPreset(title: "Kidney Beans (cooked)", volume_mL: 235.0, weight_g: 177, calories: 225),
        ServingPreset(title: "Lentils (cooked)", volume_mL: 235.0, weight_g: 198, calories: 226),
        ServingPreset(title: "Lima Beans (cooked)", volume_mL: 235.0, weight_g: 188, calories: 216),
        ServingPreset(title: "Navy Beans (cooked)", volume_mL: 235.0, weight_g: 182, calories: 255),
        ServingPreset(title: "Pinto Beans (cooked)", volume_mL: 235.0, weight_g: 171, calories: 245),
        ServingPreset(title: "Refried Beans (canned)", volume_mL: 235.0, weight_g: 238, calories: 217),
        ServingPreset(title: "Refried Beans, fat free (canned)", volume_mL: 235.0, weight_g: 231, calories: 183),
        ServingPreset(title: "Split Peas (cooked)", volume_mL: 235.0, weight_g: 196, calories: 227),
        ServingPreset(title: "Tofu (fried)", weight_g: 28, calories: 77),
        ServingPreset(title: "White Beans (cooked)", volume_mL: 235.0, weight_g: 179, calories: 249),
    ],
    .grainsPasta: [
        ServingPreset(title: "Brown Rice (cooked)", volume_mL: 235.0, weight_g: 195, calories: 218),
        ServingPreset(title: "Couscous (cooked)", volume_mL: 235.0, weight_g: 157, calories: 176),
        ServingPreset(title: "Pasta (cooked)", volume_mL: 235.0, weight_g: 140, calories: 221),
        ServingPreset(title: "Quinoa (cooked)", volume_mL: 235.0, weight_g: 185, calories: 222),
        ServingPreset(title: "White Rice (cooked)", volume_mL: 235.0, weight_g: 186, calories: 242),
        ServingPreset(title: "Whole-wheat Pasta (cooked)", volume_mL: 235.0, weight_g: 140, calories: 173),
        ServingPreset(title: "Wild Rice (cooked)", volume_mL: 235.0, weight_g: 164, calories: 166),
    ],
    .soupSauces: [
        ServingPreset(title: "Chicken Noodle Soup", volume_mL: 240.0, calories: 120),
        ServingPreset(title: "Vegetable Beef Soup", volume_mL: 240.0, calories: 110),
    ],
    .vegetables: [
        ServingPreset(title: "Artichokes (boiled)", weight_g: 90, calories: 48),
        ServingPreset(title: "Asparagus (boiled)", weight_g: 90, calories: 20),
        ServingPreset(title: "Baked Potato", weight_g: 173, calories: 160),
        ServingPreset(title: "Broccoli (boiled)", weight_g: 90, calories: 31),
        ServingPreset(title: "Brussels Sprouts (boiled)", weight_g: 90, calories: 32),
        ServingPreset(title: "Carrots (boiled)", weight_g: 90, calories: 31),
        ServingPreset(title: "Carrots (raw)", weight_g: 90, calories: 38),
        ServingPreset(title: "Cauliflower (boiled)", weight_g: 90, calories: 20),
        ServingPreset(title: "Coleslaw", weight_g: 60, calories: 47),
        ServingPreset(title: "Eggplant (boiled)", weight_g: 99, calories: 33),
        ServingPreset(title: "Kale (boiled)", weight_g: 130, calories: 39),
        ServingPreset(title: "Portabella Mushroom (grilled)", weight_g: 121, calories: 35),
        ServingPreset(title: "Potato Salad", weight_g: 250, calories: 357),
        ServingPreset(title: "Potatoes (boiled)", weight_g: 136, calories: 118),
        ServingPreset(title: "Potatoes au gratin", weight_g: 245, calories: 323),
        ServingPreset(title: "Scalloped Potatoes", weight_g: 245, calories: 216),
        ServingPreset(title: "Sweet Corn Ear (boiled)", weight_g: 103, calories: 100),
        ServingPreset(title: "Sweet Potato (baked)", weight_g: 100, calories: 92),
        ServingPreset(title: "Sweet Potato (boiled)", weight_g: 328, calories: 249),
        ServingPreset(title: "Sweet Potato (cooked, candied)", weight_g: 105, calories: 151),
        ServingPreset(title: "White Mushroom (stir fry)", weight_g: 108, calories: 28),
        ServingPreset(title: "Yam (boiled)", weight_g: 136, calories: 155),
    ],
    .bakedGoods: [
        ServingPreset(title: "Apple Pie Slice", weight_g: 117, calories: 277),
        ServingPreset(title: "Bagel, Cinnamon-raisin", weight_g: 105, calories: 287),
        ServingPreset(title: "Bagel, Everything", weight_g: 105, calories: 289),
        ServingPreset(title: "Bagel, Oat-bran", weight_g: 105, calories: 267),
        ServingPreset(title: "Biscuit", weight_g: 51, calories: 186),
        ServingPreset(title: "Blueberry Muffin", weight_g: 113, calories: 444),
        ServingPreset(title: "Bread Slice, Cracked-wheat", weight_g: 25, calories: 65),
        ServingPreset(title: "Bread Slice, French/Sourdough", weight_g: 64, calories: 185),
        ServingPreset(title: "Bread Slice, Multi-grain", weight_g: 26, calories: 69),
        ServingPreset(title: "Bread Slice, Oat-bran", weight_g: 30, calories: 71),
        ServingPreset(title: "Bread Slice, Raisin (toasted)", weight_g: 24, calories: 71),
        ServingPreset(title: "Bread Stick", weight_g: 10, calories: 41),
        ServingPreset(title: "Brownie", weight_g: 56, calories: 227),
        ServingPreset(title: "Chocolate Chip Cookie", weight_g: 28, calories: 136),
        ServingPreset(title: "Coffeecake (w/crumb topping)", weight_g: 57, calories: 238),
        ServingPreset(title: "Corn Muffin", weight_g: 113, calories: 344),
        ServingPreset(title: "Corn Tortilla", weight_g: 30, calories: 65),
        ServingPreset(title: "Croissant, Butter", weight_g: 57, calories: 231),
        ServingPreset(title: "Croutons", weight_g: 14, calories: 58),
        ServingPreset(title: "Danish Pastry", weight_g: 71, calories: 265),
        ServingPreset(title: "Dinner Roll", weight_g: 35, calories: 108),
        ServingPreset(title: "Doughnut (cake-type, frosted)", weight_g: 43, calories: 194),
        ServingPreset(title: "English Muffin (toasted)", weight_g: 57, calories: 134),
        ServingPreset(title: "English Muffin, Cinn-raisin (toasted)", weight_g: 52, calories: 144),
        ServingPreset(title: "English Muffin, Mixed-grain (toasted)", weight_g: 61, calories: 156),
        ServingPreset(title: "English Muffin, Whole-wheat (toasted)", weight_g: 52, calories: 126),
        ServingPreset(title: "Flour Tortilla", weight_g: 30, calories: 94),
        ServingPreset(title: "Fortune Cookie", weight_g: 8, calories: 30),
        ServingPreset(title: "French Toast Slice (2% milk)", weight_g: 65, calories: 149),
        ServingPreset(title: "Hard Roll", weight_g: 57, calories: 167),
        ServingPreset(title: "Oat Bran Muffin", weight_g: 113, calories: 305),
        ServingPreset(title: "Oatmeal Cookie", weight_g: 25, calories: 112),
        ServingPreset(title: "Pancake (4” diameter)", weight_g: 38, calories: 86),
        ServingPreset(title: "Pancake (6” diameter)", weight_g: 77, calories: 175),
        ServingPreset(title: "Pita (large)", weight_g: 60, calories: 165),
        ServingPreset(title: "Pita, Whole-wheat (large)", weight_g: 64, calories: 170),
        ServingPreset(title: "Rye Crackers", weight_g: 14, calories: 47),
        ServingPreset(title: "Shortbread", weight_g: 8, calories: 40),
        ServingPreset(title: "Taco/Tostada shell (corn, baked)", weight_g: 12, calories: 58),
        ServingPreset(title: "Waffle (7” diameter)", weight_g: 75, calories: 218),
        ServingPreset(title: "Whole-wheat Crackers", weight_g: 28, calories: 120),
    ],
    .saladDressings: [
        ServingPreset(title: "Salad Dressing, 1000 Island, fat free", weight_g: 16, calories: 21),
        ServingPreset(title: "Salad Dressing, 1000 Island", weight_g: 16, calories: 59),
        ServingPreset(title: "Salad Dressing, Ranch, fat free", weight_g: 14, calories: 17),
        ServingPreset(title: "Salad Dressing, Ranch", weight_g: 15, calories: 73),
    ],
    .egg: [
        ServingPreset(title: "Egg (large, fried)", weight_g: 46, calories: 90),
        ServingPreset(title: "Egg (large, hard-boiled)", weight_g: 50, calories: 78),
        ServingPreset(title: "Egg (large, omelet)", weight_g: 61, calories: 94),
        ServingPreset(title: "Egg (large, poached)", weight_g: 50, calories: 69),
        ServingPreset(title: "Egg (large, scrambled)", weight_g: 61, calories: 91),
        ServingPreset(title: "Egg White (large, raw)", weight_g: 33, calories: 17),
    ],
]