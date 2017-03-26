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

    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var existKeywordTable: UITableView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    let typePickerData = ["Food", "Unit"]
    
    struct keyword {
        var name: String?
        var type: String?
        var isExisted: Bool?
    }
    
    var newKeyword = keyword(name: "New", type: "Food", isExisted: false)
    var keywordArray: [keyword] = []

    
    var notificationToken: NotificationToken!
    var realm: Realm!
    
    
    func setupRealm() {
        let username = "Allen"
        let password = "test"
        SyncUser.logIn(with: .usernamePassword(username: username, password: password, register: false), server: URL(string: "http://127.0.0.1:9080")!) { user, error in
            guard let user = user else {
                fatalError(String(describing: error))
            }
            
            DispatchQueue.main.async {
                // Open Realm
                let configuration = Realm.Configuration(
                    syncConfiguration: SyncConfiguration(user: user, realmURL: URL(string: "realm://127.0.0.1:9080/~/realmtasks")!)
                )
                self.realm = try! Realm(configuration: configuration)
                
                // Show initial tasks
                func updateList() {
//                    if self.items.realm == nil, let list = self.realm.objects(TaskList.self).first {
//                        self.items = list.items
//                    }
//                    self.tableView.reloadData()
                }
                updateList()
                
                // Notify us when Realm changes
                self.notificationToken = self.realm.addNotificationBlock { _ in
                    updateList()
                }
            }
        }
    }
    
    deinit {
        notificationToken.stop()
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        existKeywordTable.dataSource = self
        existKeywordTable.delegate = self
        keywordTextField.delegate = self
        readFromRealm()
//        keywordArray.append(newKeyword)
        existKeywordTable.reloadData()
    }

    @IBAction func AddButton(_ sender: Any) {
        if (keywordTextField.text != "") {
            self.newKeyword.name = keywordTextField.text
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextField.resignFirstResponder()
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keywordArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = self.keywordArray[indexPath.row].name! + " (" + self.keywordArray[indexPath.row].type! + ")"
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
    
    func readFromRealm() {
        let realm = try! Realm()
        let oldKeywordList = realm.objects(Keyword.self)
        for item in 0...(oldKeywordList.count-1) {
            let oldKeyword = keyword(name:oldKeywordList[item].name, type:oldKeywordList[item].type, isExisted: true)
            self.keywordArray.append(oldKeyword)
        }
    }
    
    func writeIntoRealm() {
        let realm = try! Realm()
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
                realm.add(newKeywordToRealm)
                i += 1
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
