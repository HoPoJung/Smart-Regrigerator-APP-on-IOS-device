//
//  RecognitionController.swift
//  SmartRefrigeratorApp
//
//  Created by Yuan-Pu Hsu on 16/02/2017.
//  Copyright © 2017 Peter. All rights reserved.
//

import Foundation

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
    
    
    public init() {
        let firstNode = foodNode(quantity: 1, unit: "piece", foodName: "Nothing", expirationDate: Date())
        self.headNode = firstNode
        self.tailNode = firstNode
    }
    
    public func inputWord(newWord: String)->Bool{
        return false
    }
}
