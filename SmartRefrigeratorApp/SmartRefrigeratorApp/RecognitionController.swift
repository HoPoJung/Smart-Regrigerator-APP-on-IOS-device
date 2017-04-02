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
        readFromRealm()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    public func inputWord(newWord: String)->Bool{
        self.wordArray.append(newWord)
        switch self.inputState! {
        case 1:
            if searchKeyword(newWord: newWord, fromArray: foodKeywordArray) {
                self.newNode!.foodName = newWord
                self.inputState = 2
            }
            else {
                // pending to confirm
            }
        case 2:
            if searchKeyword(newWord: newWord, fromArray: quantityKeywordArray) {
                self.newNode!.quantity =
            }
        case 3:
            if searchKeyword(newWord: newWord, fromArray: unitKeywordArray) {
                
            }

        case 4:
            self.inputState = 1
        default:
            print("Input state error")
        }
        return false
    }
    
    private func searchKeyword(newWord: String, fromArray keywordArray: Array<Keyword>) -> Bool{
        for item in keywordArray {
            if newWord == item.name {
                return true
            }
        }
        return false
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
