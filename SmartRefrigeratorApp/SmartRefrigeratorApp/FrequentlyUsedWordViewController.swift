//
//  FrequentlyUsedWordViewController.swift
//  SmartRefrigeratorApp
//
//  Created by Yuan-Pu Hsu on 12/03/2017.
//  Copyright © 2017 Peter. All rights reserved.
//

import UIKit
import RealmSwift

class FrequentlyUsedWordViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    //MARK: Init
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var existKeywordTable: UITableView!
    @IBOutlet weak var multiplierTextField: UITextField!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!

    
    let typePickerData = ["Food", "Unit", "Quantity"]
    
    struct keyword {
        var name: String?
        var type: String?
        var multiplier: Int?
        var isExisted: Bool?
    }
    
    var newKeyword = keyword(name: "New", type: "Food", multiplier: 1, isExisted: false)
    var keywordArray: [keyword] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        existKeywordTable.dataSource = self
        existKeywordTable.delegate = self
        keywordTextField.delegate = self
        multiplierTextField.delegate = self
        multiplierTextField.isEnabled = false
        readFromRealm()
//        keywordArray.append(newKeyword)
        existKeywordTable.reloadData()
    }

    // MARK: IBActions
    @IBAction func AddButton(_ sender: Any) {
        if (keywordTextField.text != "") {
            self.newKeyword.name = self.keywordTextField.text
            self.newKeyword.multiplier = Int(self.multiplierTextField.text!)
            keywordTextField.text = ""
            self.keywordArray.append(newKeyword)
            print("Add new keyword: " + self.newKeyword.name! + ", type: " + self.newKeyword.type!)
            self.existKeywordTable.reloadData()
        }
    }
    @IBAction func ExitButton(_ sender: Any) {
        writeIntoRealm()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func editTableButton(_ sender: Any) {
        if existKeywordTable.isEditing {
            existKeywordTable.setEditing(false, animated: false)
            rightBarButtonItem.title = "Edit"
        }
        else {
            existKeywordTable.setEditing(true, animated: true)
            rightBarButtonItem.title = "Done"
        }
        DispatchQueue.main.async {
            self.existKeywordTable.reloadData()
        }
    }
    
    
    // MARK: pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typePickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.newKeyword.type = typePickerData[row]
        if (typePickerData[row] == "Food") {
            self.multiplierTextField.isEnabled = false
        }
        else {
            self.multiplierTextField.isEnabled = true
        }
    }
    
    // MARK: textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextField.resignFirstResponder()
        multiplierTextField.resignFirstResponder()
        return false
    }
    
    // MARK: tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keywordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        let index = indexPath.row
        cell.textLabel?.text = self.keywordArray[index].name! + " (" + self.keywordArray[index].type! + ")"
        cell.detailTextLabel?.text = String(self.keywordArray[index].multiplier!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            self.keywordArray.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.existKeywordTable.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tmpKeywordItem = self.keywordArray[sourceIndexPath.row]
        if (sourceIndexPath.row < destinationIndexPath.row) {
            for item in sourceIndexPath.row...destinationIndexPath.row-1 {
                self.keywordArray[item] = self.keywordArray[item+1]
            }
        }
        else {
            for item in (destinationIndexPath.row+1...sourceIndexPath.row).reversed() {
                self.keywordArray[item] = self.keywordArray[item-1]
            }
        }
        self.keywordArray[destinationIndexPath.row] = tmpKeywordItem
    }
    
    
    // MARK: RealmFunctions
    func readFromRealm() {
        let realm = realmWithPath()
        if (realm.objects(Keyword.self).count > 0) {
            let oldKeywordList = realm.objects(Keyword.self)
            for item in 0...(oldKeywordList.count-1) {
                let oldKeyword = keyword(name:oldKeywordList[item].name, type:oldKeywordList[item].type, multiplier: oldKeywordList[item].multiplier, isExisted: true)
                self.keywordArray.append(oldKeyword)
            }
        }
    }
    
    func writeIntoRealm() {
        let realm = realmWithPath()
        let oldKeywordList = realm.objects(Keyword.self)
        try! realm.write {
            realm.delete(oldKeywordList)
            var i:Int = 1
            for item in keywordArray {
                print("Adding: " + item.name! + ", p=" + String(i))
                let newKeywordToRealm = Keyword()
                newKeywordToRealm.type = item.type
                newKeywordToRealm.name = item.name
                newKeywordToRealm.priority = i
                newKeywordToRealm.multiplier = item.multiplier!
                realm.add(newKeywordToRealm)
                i += 1
            }
        }
    }
    
    
    func realmWithPath() -> Realm {
        if Constants.dev {
            let realmDatabaseFileURL = URL(fileURLWithPath: "/Users/Allen_Hsu/Documents/ios workspace/Swift/Smart-Regrigerator-APP-on-IOS-device/SRDatabase/SRDatabase.realm")
            // CAUTION!! You have to change this or change the Constants value to false when using different computer.
            do {
                let tempRealm = try Realm(fileURL: realmDatabaseFileURL)
                return tempRealm
            } catch {
                print("File error when accessing Realm.")
            }
        }
        
        return try! Realm()
    }

}
