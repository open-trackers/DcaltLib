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
        ServingPreset("Beef Brisket (lean, braised)", weight_g: 100, calories: 221),
        ServingPreset("Beef Composite (1/8” trimmed, cooked)", weight_g: 100, calories: 291),
        ServingPreset("Beef Composite (lean, cooked)", weight_g: 100, calories: 212),
        ServingPreset("Beef Rib (lean, braised, no bone)", weight_g: 100, calories: 228),
        ServingPreset("Beef Rib Eye (trimmed of fat, broiled)", weight_g: 236, calories: 484),
        ServingPreset("Beef Tenderloin (1/8” trimmed, broiled)", weight_g: 454, calories: 907),
        ServingPreset("Beef Tenderloin (trimmed of fat, broiled)", weight_g: 87, calories: 168),
        ServingPreset("Beef Top Sirloin (trimmed of fat, broiled)", weight_g: 292, calories: 534),
        ServingPreset("Ground Beef Patty, 70/30 (broiled)", weight_g: 85, calories: 232),
        ServingPreset("Ground Beef Patty, 70/30 (pan-broiled)", weight_g: 85, calories: 202),
        ServingPreset("Ground Beef Patty, 75/25 (pan-broiled)", weight_g: 85, calories: 210),
        ServingPreset("Ground Beef Patty, 80/20 (pan-broiled)", weight_g: 85, calories: 209),
        ServingPreset("Ground Beef Patty, 85/15 (pan-broiled)", weight_g: 85, calories: 197),
        ServingPreset("Ground Beef Patty, 90/10 (pan-broiled)", weight_g: 85, calories: 173),
        ServingPreset("Ground Beef Patty, 95/5 (pan-broiled)", weight_g: 85, calories: 139),
        ServingPreset("Pot Roast (lean, braised)", weight_g: 100, calories: 212),
    ],
    .fruit: [
        ServingPreset("Apple (chopped)", volume_mL: 235.0, weight_g: 125, calories: 65),
        ServingPreset("Apple", weight_g: 182, calories: 95),
        ServingPreset("Avocado (pureed)", volume_mL: 235.0, weight_g: 230, calories: 384),
        ServingPreset("Avocado (sliced)", volume_mL: 235.0, weight_g: 146, calories: 234),
        ServingPreset("Banana (mashed)", volume_mL: 235.0, weight_g: 225, calories: 200),
        ServingPreset("Banana", weight_g: 118, calories: 105),
        ServingPreset("Blackberries", volume_mL: 235.0, weight_g: 144, calories: 62),
        ServingPreset("Blueberries", volume_mL: 235.0, weight_g: 148, calories: 84),
        ServingPreset("Cantaloupe (cubed)", volume_mL: 235.0, weight_g: 160, calories: 54),
        ServingPreset("Grapefruit (sections)", volume_mL: 235.0, weight_g: 230, calories: 97),
        ServingPreset("Grapes (seedless)", volume_mL: 235.0, weight_g: 151, calories: 104),
        ServingPreset("Honeydew (diced)", volume_mL: 235.0, weight_g: 170, calories: 61),
        ServingPreset("Kiwifruit", volume_mL: 235.0, weight_g: 186, calories: 112),
        ServingPreset("Orange", weight_g: 131, calories: 62),
        ServingPreset("Orange (sectioned)", volume_mL: 235.0, weight_g: 165, calories: 81),
        ServingPreset("Peach", weight_g: 150, calories: 59),
        ServingPreset("Peach (sliced)", volume_mL: 235.0, weight_g: 154, calories: 60),
        ServingPreset("Pear", weight_g: 178, calories: 103),
        ServingPreset("Pear (sliced)", volume_mL: 235.0, weight_g: 140, calories: 81),
        ServingPreset("Pineapple (chunks)", volume_mL: 235.0, weight_g: 165, calories: 82),
        ServingPreset("Plum", weight_g: 66, calories: 30),
        ServingPreset("Plum (sliced)", volume_mL: 235.0, weight_g: 165, calories: 76),
        ServingPreset("Raspberries", volume_mL: 235.0, weight_g: 123, calories: 64),
        ServingPreset("Strawberries (sliced)", volume_mL: 235.0, weight_g: 166, calories: 53),
        ServingPreset("Tangerine (sectioned)", volume_mL: 235.0, weight_g: 195, calories: 103),
        ServingPreset("Watermelon (diced)", volume_mL: 235.0, weight_g: 152, calories: 46),
    ],
    .snacks: [
        ServingPreset("Popcorn (air popped)", weight_g: 28, calories: 110),
        ServingPreset("Potato Chips", weight_g: 100, calories: 542),
        ServingPreset("Pretzels (hard)", weight_g: 60, calories: 229),
        ServingPreset("Raisins", volume_mL: 60.0, weight_g: 40, calories: 120),
        ServingPreset("Tortilla Chips, plain", weight_g: 100, calories: 490),
    ],
    .nutsSeeds: [
        ServingPreset("Almonds (raw)", weight_g: 28, calories: 163),
        ServingPreset("Almonds (roasted)", weight_g: 28, calories: 169),
        ServingPreset("Cashews (roasted)", weight_g: 28, calories: 163),
        ServingPreset("Peanuts (roasted)", weight_g: 28, calories: 165),
        ServingPreset("Pecans (roasted)", weight_g: 28, calories: 200),
        ServingPreset("Pistachio Nuts (roasted)", weight_g: 28, calories: 160),
        ServingPreset("Sunflower Seeds", weight_g: 30, calories: 180),
    ],
    .condiments: [
        // TODO: mustard, mayonaise
        ServingPreset("Catsup", weight_g: 15, calories: 15),
        ServingPreset("Peanut Butter", volume_mL: 30.0, weight_g: 32, calories: 200),
        ServingPreset("Salsa", volume_mL: 30.0, weight_g: 30, calories: 10),
        ServingPreset("Sweet Pickle Relish", weight_g: 15, calories: 19),
    ],
    .dairy: [
        ServingPreset("Blue Cheese", weight_g: 28, calories: 100),
        ServingPreset("Brie Cheese", weight_g: 28, calories: 95),
        ServingPreset("Butter", weight_g: 5, calories: 36),
        ServingPreset("Butter (whipped)", weight_g: 4, calories: 27),
        ServingPreset("Camembert Cheese", weight_g: 28, calories: 85),
        ServingPreset("Cheddar Cheese", weight_g: 28, calories: 114),
        ServingPreset("Cheese, low fat (cheddar or colby)", weight_g: 28, calories: 49),
        ServingPreset("Cheese spread (cream cheese base)", weight_g: 28, calories: 84),
        ServingPreset("Colby Cheese", weight_g: 28, calories: 112),
        ServingPreset("Cottage Cheese, 1%", weight_g: 113, calories: 81),
        ServingPreset("Cottage Cheese, 2%", weight_g: 113, calories: 97),
        ServingPreset("Cottage Cheese", weight_g: 113, calories: 111),
        ServingPreset("Cream Cheese, fat free", weight_g: 85, calories: 89),
        ServingPreset("Cream Cheese", weight_g: 85, calories: 291),
        ServingPreset("Feta Cheese", weight_g: 28, calories: 74),
        ServingPreset("Fruit Yogurt, low fat", weight_g: 170, calories: 173),
        ServingPreset("Fruit Yogurt, nonfat", weight_g: 170, calories: 161),
        ServingPreset("Goat Cheese, hard", weight_g: 28, calories: 128),
        ServingPreset("Goat Cheese, soft", weight_g: 28, calories: 76),
        ServingPreset("Gouda Cheese", weight_g: 28, calories: 101),
        ServingPreset("Gruyere Cheese", weight_g: 28, calories: 117),
        ServingPreset("Half and Half", volume_mL: 30, calories: 39),
        ServingPreset("Milk, 1%", volume_mL: 240.0, calories: 103),
        ServingPreset("Milk, 2%", volume_mL: 240.0, calories: 122),
        ServingPreset("Milk, skim or fat free", volume_mL: 240.0, calories: 86),
        ServingPreset("Milk, whole", volume_mL: 240.0, calories: 150),
        ServingPreset("Monterey Cheese", weight_g: 28, calories: 106),
        ServingPreset("Mozzarella Cheese, part skim", weight_g: 28, calories: 72),
        ServingPreset("Mozzarella Cheese, part skim, low moisture", weight_g: 28, calories: 85),
        ServingPreset("Mozzarella Cheese, whole milk", weight_g: 28, calories: 85),
        ServingPreset("Mozzarella Cheese, whole milk, low moisture", weight_g: 28, calories: 90),
        ServingPreset("Mozzarella Cheese", weight_g: 28, calories: 78),
        ServingPreset("Parmesan Cheese, reduced fat", weight_g: 5, calories: 13),
        ServingPreset("Parmesan Cheese", weight_g: 5, calories: 22),
        ServingPreset("Plain Yogurt, low fat", weight_g: 170, calories: 107),
        ServingPreset("Plain Yogurt, skim milk", weight_g: 170, calories: 95),
        ServingPreset("Plain Yogurt, whole milk", weight_g: 170, calories: 104),
        ServingPreset("Provolone Cheese", weight_g: 28, calories: 100),
        ServingPreset("Queso Anejo (cheese)", weight_g: 28, calories: 106),
        ServingPreset("Queso Asadero (cheese)", weight_g: 28, calories: 101),
        ServingPreset("Queso Chihuahua (cheese)", weight_g: 28, calories: 106),
        ServingPreset("Ricotta Cheese, part skim milk", weight_g: 28, calories: 40),
        ServingPreset("Ricotta Cheese, whole milk", weight_g: 28, calories: 49),
        ServingPreset("Sour Cream, fat free", weight_g: 100, calories: 74),
        ServingPreset("Sour Cream, light", weight_g: 100, calories: 138),
        ServingPreset("Sour Cream, reduced fat", weight_g: 100, calories: 181),
        ServingPreset("Swiss Cheese, reduced fat", weight_g: 28, calories: 49),
        ServingPreset("Swiss Cheese", weight_g: 28, calories: 108),
        ServingPreset("Table Cream", volume_mL: 30, calories: 59),
    ],
    .beverage: [
        ServingPreset("Apple Juice, unsweetened", volume_mL: 240.0, calories: 112),
        ServingPreset("Beer, light", volume_mL: 355, calories: 103),
        ServingPreset("Beer", volume_mL: 355, calories: 153),
        ServingPreset("Carbonated Soda, sweetened", volume_mL: 355, calories: 150),
        ServingPreset("Dessert Wine, sweet", volume_mL: 104, calories: 165),
        ServingPreset("Distilled Spirit, 100 proof", volume_mL: 44, calories: 124),
        ServingPreset("Distilled Spirit, 80 proof", volume_mL: 44, calories: 97),
        ServingPreset("Distilled Spirit, 86 proof", volume_mL: 44, calories: 105),
        ServingPreset("Eggnog", volume_mL: 250, weight_g: 254, calories: 224),
        ServingPreset("Grapefruit Juice, unsweetened", volume_mL: 240.0, weight_g: 247, calories: 96),
        ServingPreset("Lemonade", volume_mL: 360.0, calories: 100),
        ServingPreset("Orange Juice", volume_mL: 250.0, weight_g: 249, calories: 120),
        ServingPreset("Pineapple Juice, unsweetened", volume_mL: 250.0, weight_g: 250, calories: 133),
        ServingPreset("Pomegranate Juice", volume_mL: 250.0, weight_g: 250, calories: 135),
        ServingPreset("Table Wine, light", volume_mL: 148, calories: 73),
        ServingPreset("Table Wine", volume_mL: 148, calories: 123),
        ServingPreset("Tangerine Juice", volume_mL: 250.0, weight_g: 247, calories: 106),
        ServingPreset("Tonic Water", volume_mL: 355, calories: 125),
    ],
    .cereals: [
        ServingPreset("Oats (w/water, cooked)", weight_g: 234, calories: 159),
    ],
    .fishSeafood: [
        ServingPreset("Rainbow Trout, farmed (dry heat)", weight_g: 85, calories: 143),
        ServingPreset("Rainbow Trout, wild (dry heat)", weight_g: 85, calories: 130),
        ServingPreset("Salmon, Atlantic, farmed (dry heat)", weight_g: 85, calories: 175),
        ServingPreset("Salmon, Atlantic, wild (dry heat)", weight_g: 85, calories: 154),
        ServingPreset("Salmon, Chinook (dry heat)", weight_g: 85, calories: 196),
        ServingPreset("Salmon, Chinook (smoked)", weight_g: 85, calories: 100),
        ServingPreset("Snapper (dry heat)", weight_g: 85, calories: 109),
        ServingPreset("Swordfish (dry heat)", weight_g: 85, calories: 146),
        ServingPreset("Trout (dry heat)", weight_g: 85, calories: 162),
        ServingPreset("Tuna, light (in water, drained)", weight_g: 85, calories: 98),
    ],
    .pork: [
        ServingPreset("Bacon (microwaved)", weight_g: 15, calories: 76),
        ServingPreset("Bacon (pan-fried)", weight_g: 24, calories: 126),
        ServingPreset("Ham (lean, cooked)", weight_g: 100, calories: 122),
        ServingPreset("Pork Loin (boneless, lean, broiled)", weight_g: 100, calories: 193),
        ServingPreset("Pork Chop (broiled)", weight_g: 100, calories: 259),
    ],
    .poultry: [
        ServingPreset("Chicken (fried, meat + skin)", weight_g: 100, calories: 331),
        ServingPreset("Chicken (fried, meat only)", weight_g: 100, calories: 288),
        ServingPreset("Chicken (roasted, meat + skin)", weight_g: 100, calories: 300),
        ServingPreset("Chicken (roasted, meat only)", weight_g: 100, calories: 239),
        ServingPreset("Chicken (rotisserie, meat + skin)", weight_g: 100, calories: 260),
        ServingPreset("Chicken (rotisserie, meat only)", weight_g: 100, calories: 205),
        ServingPreset("Chicken (stewed, meat only)", weight_g: 100, calories: 209),
        ServingPreset("Chicken Breast (fried, meat + skin)", weight_g: 100, calories: 222),
        ServingPreset("Chicken Breast (fried, meat only)", weight_g: 100, calories: 186),
        ServingPreset("Chicken Breast (roasted, meat + skin)", weight_g: 100, calories: 197),
        ServingPreset("Chicken Breast (roasted, meat only)", weight_g: 100, calories: 164),
        ServingPreset("Chicken Breast (rotisserie, meat + skin)", weight_g: 100, calories: 184),
        ServingPreset("Chicken Breast (rotisserie, meat only)", weight_g: 100, calories: 148),
        ServingPreset("Chicken Breast (stewed, meat only)", weight_g: 100, calories: 151),
        ServingPreset("Chicken Breast Tenders (microwaved)", weight_g: 100, calories: 252),
        ServingPreset("Ground Turkey Patty (85/15, broiled)", weight_g: 100, calories: 249),
        ServingPreset("Ground Turkey Patty (93/7, broiled)", weight_g: 100, calories: 207),
        ServingPreset("Ground Turkey Patty (breaded, fried)", weight_g: 100, calories: 283),
        ServingPreset("Ground Turkey Patty (fat-free, broiled)", weight_g: 100, calories: 138),
        ServingPreset("Pate de foie gras (smoked)", weight_g: 28, calories: 131),
        ServingPreset("Turkey (roasted, meat + skin)", weight_g: 100, calories: 244),
        ServingPreset("Turkey (roasted, meat only)", weight_g: 100, calories: 170),
        ServingPreset("Turkey Breast (roasted, meat only)", weight_g: 100, calories: 134),
    ],
    .mealsEntreesSides: [
        ServingPreset("Breaded Chicken Sandwich with Cheese", weight_g: 228, calories: 631),
        ServingPreset("French Fries", weight_g: 100, calories: 319),
        ServingPreset("Grilled Chicken Sandwich", weight_g: 229, calories: 419),
        ServingPreset("Cheeseburger (large, w/veg+cond)", weight_g: 233, calories: 480),
        ServingPreset("Hamburger (large, w/veg+cond)", weight_g: 171, calories: 437),
        ServingPreset("Pizza Slice, cheese only, thin crust", weight_g: 63, calories: 192),
        ServingPreset("Pizza Slice, meat+veg, regular crust", weight_g: 136, calories: 331),
        ServingPreset("Sausage Biscuit with Egg", weight_g: 117, calories: 440),
    ],
    .legumes: [
        ServingPreset("Baked Beans", volume_mL: 235.0, weight_g: 253, calories: 266),
        ServingPreset("Black Beans (cooked)", volume_mL: 235.0, weight_g: 172, calories: 227),
        ServingPreset("Chickpeas (cooked)", volume_mL: 235.0, weight_g: 164, calories: 269),
        ServingPreset("Fava Beans (cooked)", volume_mL: 235.0, weight_g: 170, calories: 187),
        ServingPreset("Great Northern Beans (cooked)", volume_mL: 235.0, weight_g: 177, calories: 209),
        ServingPreset("Hummus", volume_mL: 235.0, weight_g: 246, calories: 408),
        ServingPreset("Kidney Beans (cooked)", volume_mL: 235.0, weight_g: 177, calories: 225),
        ServingPreset("Lentils (cooked)", volume_mL: 235.0, weight_g: 198, calories: 226),
        ServingPreset("Lima Beans (cooked)", volume_mL: 235.0, weight_g: 188, calories: 216),
        ServingPreset("Navy Beans (cooked)", volume_mL: 235.0, weight_g: 182, calories: 255),
        ServingPreset("Pinto Beans (cooked)", volume_mL: 235.0, weight_g: 171, calories: 245),
        ServingPreset("Refried Beans (canned)", volume_mL: 235.0, weight_g: 238, calories: 217),
        ServingPreset("Refried Beans, fat free (canned)", volume_mL: 235.0, weight_g: 231, calories: 183),
        ServingPreset("Split Peas (cooked)", volume_mL: 235.0, weight_g: 196, calories: 227),
        ServingPreset("Tofu (fried)", weight_g: 28, calories: 77),
        ServingPreset("White Beans (cooked)", volume_mL: 235.0, weight_g: 179, calories: 249),
    ],
    .grainsPasta: [
        ServingPreset("Brown Rice (cooked)", volume_mL: 235.0, weight_g: 195, calories: 218),
        ServingPreset("Couscous (cooked)", volume_mL: 235.0, weight_g: 157, calories: 176),
        ServingPreset("Pasta (cooked)", volume_mL: 235.0, weight_g: 140, calories: 221),
        ServingPreset("Quinoa (cooked)", volume_mL: 235.0, weight_g: 185, calories: 222),
        ServingPreset("White Rice (cooked)", volume_mL: 235.0, weight_g: 186, calories: 242),
        ServingPreset("Whole-wheat Pasta (cooked)", volume_mL: 235.0, weight_g: 140, calories: 173),
        ServingPreset("Wild Rice (cooked)", volume_mL: 235.0, weight_g: 164, calories: 166),
    ],
    .soupSauces: [
        ServingPreset("Chicken Noodle Soup", volume_mL: 240.0, calories: 120),
        ServingPreset("Vegetable Beef Soup", volume_mL: 240.0, calories: 110),
    ],
    .vegetables: [
        ServingPreset("Artichokes (boiled)", weight_g: 90, calories: 48),
        ServingPreset("Asparagus (boiled)", weight_g: 90, calories: 20),
        ServingPreset("Baked Potato", weight_g: 173, calories: 160),
        ServingPreset("Broccoli (boiled)", weight_g: 90, calories: 31),
        ServingPreset("Brussels Sprouts (boiled)", weight_g: 90, calories: 32),
        ServingPreset("Carrots (boiled)", weight_g: 90, calories: 31),
        ServingPreset("Carrots (raw)", weight_g: 90, calories: 38),
        ServingPreset("Cauliflower (boiled)", weight_g: 90, calories: 20),
        ServingPreset("Coleslaw", weight_g: 60, calories: 47),
        ServingPreset("Eggplant (boiled)", weight_g: 99, calories: 33),
        ServingPreset("Kale (boiled)", weight_g: 130, calories: 39),
        ServingPreset("Portabella Mushroom (grilled)", weight_g: 121, calories: 35),
        ServingPreset("Potato Salad", weight_g: 250, calories: 357),
        ServingPreset("Potatoes (boiled)", weight_g: 136, calories: 118),
        ServingPreset("Potatoes au gratin", weight_g: 245, calories: 323),
        ServingPreset("Scalloped Potatoes", weight_g: 245, calories: 216),
        ServingPreset("Sweet Corn Ear (boiled)", weight_g: 103, calories: 100),
        ServingPreset("Sweet Potato (baked)", weight_g: 100, calories: 92),
        ServingPreset("Sweet Potato (boiled)", weight_g: 328, calories: 249),
        ServingPreset("Sweet Potato (cooked, candied)", weight_g: 105, calories: 151),
        ServingPreset("White Mushroom (stir fry)", weight_g: 108, calories: 28),
        ServingPreset("Yam (boiled)", weight_g: 136, calories: 155),
    ],
    .bakedGoods: [
        ServingPreset("Apple Pie Slice", weight_g: 117, calories: 277),
        ServingPreset("Bagel, Cinnamon-raisin", weight_g: 105, calories: 287),
        ServingPreset("Bagel, Everything", weight_g: 105, calories: 289),
        ServingPreset("Bagel, Oat-bran", weight_g: 105, calories: 267),
        ServingPreset("Biscuit", weight_g: 51, calories: 186),
        ServingPreset("Blueberry Muffin", weight_g: 113, calories: 444),
        ServingPreset("Bread Slice, Cracked-wheat", weight_g: 25, calories: 65),
        ServingPreset("Bread Slice, French/Sourdough", weight_g: 64, calories: 185),
        ServingPreset("Bread Slice, Multi-grain", weight_g: 26, calories: 69),
        ServingPreset("Bread Slice, Oat-bran", weight_g: 30, calories: 71),
        ServingPreset("Bread Slice, Raisin (toasted)", weight_g: 24, calories: 71),
        ServingPreset("Bread Stick", weight_g: 10, calories: 41),
        ServingPreset("Brownie", weight_g: 56, calories: 227),
        ServingPreset("Chocolate Chip Cookie", weight_g: 28, calories: 136),
        ServingPreset("Coffeecake (w/crumb topping)", weight_g: 57, calories: 238),
        ServingPreset("Corn Muffin", weight_g: 113, calories: 344),
        ServingPreset("Corn Tortilla", weight_g: 30, calories: 65),
        ServingPreset("Croissant, Butter", weight_g: 57, calories: 231),
        ServingPreset("Croutons", weight_g: 14, calories: 58),
        ServingPreset("Danish Pastry", weight_g: 71, calories: 265),
        ServingPreset("Dinner Roll", weight_g: 35, calories: 108),
        ServingPreset("Doughnut (cake-type, frosted)", weight_g: 43, calories: 194),
        ServingPreset("English Muffin (toasted)", weight_g: 57, calories: 134),
        ServingPreset("English Muffin, Cinn-raisin (toasted)", weight_g: 52, calories: 144),
        ServingPreset("English Muffin, Mixed-grain (toasted)", weight_g: 61, calories: 156),
        ServingPreset("English Muffin, Whole-wheat (toasted)", weight_g: 52, calories: 126),
        ServingPreset("Flour Tortilla", weight_g: 30, calories: 94),
        ServingPreset("Fortune Cookie", weight_g: 8, calories: 30),
        ServingPreset("French Toast Slice (2% milk)", weight_g: 65, calories: 149),
        ServingPreset("Hard Roll", weight_g: 57, calories: 167),
        ServingPreset("Oat Bran Muffin", weight_g: 113, calories: 305),
        ServingPreset("Oatmeal Cookie", weight_g: 25, calories: 112),
        ServingPreset("Pancake (4” diameter)", weight_g: 38, calories: 86),
        ServingPreset("Pancake (6” diameter)", weight_g: 77, calories: 175),
        ServingPreset("Pita (large)", weight_g: 60, calories: 165),
        ServingPreset("Pita, Whole-wheat (large)", weight_g: 64, calories: 170),
        ServingPreset("Rye Crackers", weight_g: 14, calories: 47),
        ServingPreset("Shortbread", weight_g: 8, calories: 40),
        ServingPreset("Taco/Tostada shell (corn, baked)", weight_g: 12, calories: 58),
        ServingPreset("Waffle (7” diameter)", weight_g: 75, calories: 218),
        ServingPreset("Whole-wheat Crackers", weight_g: 28, calories: 120),
    ],
    .saladDressings: [
        ServingPreset("Salad Dressing, 1000 Island, fat free", weight_g: 16, calories: 21),
        ServingPreset("Salad Dressing, 1000 Island", weight_g: 16, calories: 59),
        ServingPreset("Salad Dressing, Ranch, fat free", weight_g: 14, calories: 17),
        ServingPreset("Salad Dressing, Ranch", weight_g: 15, calories: 73),
    ],
    .egg: [
        ServingPreset("Egg (large, fried)", weight_g: 46, calories: 90),
        ServingPreset("Egg (large, hard-boiled)", weight_g: 50, calories: 78),
        ServingPreset("Egg (large, omelet)", weight_g: 61, calories: 94),
        ServingPreset("Egg (large, poached)", weight_g: 50, calories: 69),
        ServingPreset("Egg (large, scrambled)", weight_g: 61, calories: 91),
        ServingPreset("Egg White (large, raw)", weight_g: 33, calories: 17),
    ],
]
