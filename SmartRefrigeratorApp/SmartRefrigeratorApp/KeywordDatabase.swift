//
//  KeywordDatabase.swift
//  SmartRefrigeratorApp
//
//  Created by Yuan-Pu Hsu on 28/02/2017.
//  Copyright © 2017 Peter. All rights reserved.
//

import Foundation
import RealmSwift

// MARK: User
class Food: Object {
    var quantity: Int?
    dynamic var unit: String?
    dynamic var foodName: String?
    dynamic var expirationDate: Date?
}

class User: Object {    
    var userName: String?
    let foodList = List<Food>()
}

// MARK: Keyword
class Keyword: Object {
    dynamic var type: String?
    dynamic var priority = 99
    dynamic var name: String?
    dynamic var multiplier = 1
}
/*
class FoodKeyword: Keyword {
    var foodName: String?
}

class UnitKeyword: Keyword {
    var unitName: String?
}

class QuantityKeyword: Keyword {
    var quantityName: String?
}
*/
