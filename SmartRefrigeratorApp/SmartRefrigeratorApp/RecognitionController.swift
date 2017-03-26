//
//  RecognitionController.swift
//  SmartRefrigeratorApp
//
//  Created by Yuan-Pu Hsu on 16/02/2017.
//  Copyright © 2017 Peter. All rights reserved.
//

import Foundation
import RealmSwift

public class RecognitionController {
    
    private class foodNode {
        var quantity: Int?
        var unit: String?
        var foodName: String?
        var expirationDate: Date?
        var nextNode: foodNode?
        public init(quantity: Int, unit: String, foodName: String, expirationDate: Date) {
            self.quantity = quantity
            self.unit = unit
            self.foodName = foodName
            self.expirationDate = expirationDate
            self.nextNode = nil
        }
    }
    
    private var headNode: foodNode?
    private var tailNode: foodNode?
    private var tempQuantity: Int?
    private var tempUnit: String?
    private var tempFoodName: String?
    private var tempExpirationDate: Date?
    private var wordArray: [String]
    private var foodArray: [foodNode]
    private var inputState: Int?
    private var foodKeywordArray: [Keyword]
    private var unitKeywordArray: [Keyword]
    
    public init() {
        let firstNode = foodNode(quantity: 1, unit: "piece", foodName: "Nothing", expirationDate: Date())
        self.headNode = firstNode
        self.tailNode = firstNode
        self.inputState = 1
        self.wordArray = []
        self.foodArray = []
        self.foodKeywordArray = []
        self.unitKeywordArray = []
        readFromRealm()
        
    }
    
    public func inputWord(newWord: String)->Bool{
        self.wordArray.append(newWord)
        
        return false
    }
    
    private func searchKeyword(newWord: String) -> String{
        return ""
    }
    
    private func readFromRealm() {
        let realm = try! Realm()
        let oldKeywordList = realm.objects(Keyword.self)
        for item in oldKeywordList {
            if (item.type == "Food") {
                self.foodKeywordArray.append(item)
            }
            else {
                self.unitKeywordArray.append(item)
            }
        }
    }

}
