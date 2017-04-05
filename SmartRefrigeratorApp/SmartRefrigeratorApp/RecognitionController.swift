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
        
        private init() {
            self.quantity = 0
            self.unit = ""
            self.foodName = ""
            self.expirationDate = nil
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
    private var quantityKeywordArray: [Keyword]
    private var newNode: foodNode?
    
    public init() {
        let firstNode = foodNode(quantity: 1, unit: "piece", foodName: "Nothing", expirationDate: Date())
        self.headNode = firstNode
        self.tailNode = firstNode
        self.newNode = firstNode
        self.inputState = 1
        self.wordArray = []
        self.foodArray = []
        self.foodKeywordArray = []
        self.unitKeywordArray = []
        self.quantityKeywordArray = []
        readFromRealm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    public func inputWord(newWord: String)->Bool{
        self.wordArray.append(newWord)
        var resultWord: Keyword?
        switch self.inputState! {
        case 1:
            resultWord = searchKeyword(newWord: newWord, fromArray: foodKeywordArray)
            self.newNode!.foodName = resultWord!.name
            self.inputState = 2
            
        case 2:
            resultWord = searchKeyword(newWord: newWord, fromArray: quantityKeywordArray)
            self.newNode!.quantity = resultWord!.multiplier
            self.inputState = 3
            
        case 3:
            resultWord = searchKeyword(newWord: newWord, fromArray: unitKeywordArray)
            self.newNode!.unit = resultWord!.name
            self.inputState = 4
            
        case 4:
            // considering not to use speech recognition for expiration date info.
            self.inputState = 1
        default:
            print("Input state error")
        }
        return false
    }
    
    private func searchKeyword(newWord: String, fromArray keywordArray: Array<Keyword>) -> Keyword{
        for item in keywordArray {
            if newWord == item.name {
                return item
            }
        }
        let pendingNewKeyword = Keyword()
        pendingNewKeyword.type = "New"
        pendingNewKeyword.name = newWord
        return pendingNewKeyword
    }
    
    private func readFromRealm() {
        let realm = try! Realm()
        let oldKeywordList = realm.objects(Keyword.self)
        for item in oldKeywordList {
            if (item.type == "Food") {
                self.foodKeywordArray.append(item)
            }
            else if (item.type == "Unit") {
                self.unitKeywordArray.append(item)
            }
            else if (item.type == "Quantity") {
                self.quantityKeywordArray.append(item)
            }
            
        }
    }

}
