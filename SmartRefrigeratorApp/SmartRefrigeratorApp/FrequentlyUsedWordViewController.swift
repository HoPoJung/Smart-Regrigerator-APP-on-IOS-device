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
    
    let typePickerData = ["Food", "Unit"]
    
    struct keyword {
        var name: String?
        var type: String?
    }
    var newKeyword = keyword(name: "New", type: "Food")
    var keywordArray: [keyword] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        existKeywordTable.dataSource = self
        existKeywordTable.delegate = self
        keywordTextField.delegate = self
        keywordArray.append(newKeyword)
    }

    @IBAction func AddButton(_ sender: Any) {
        if (keywordTextField.text != "") {
            self.newKeyword.name = keywordTextField.text
            keywordTextField.text = ""
            self.keywordArray.append(newKeyword)
            print("Add new keyword: " + self.newKeyword.name! + ", type: " + self.newKeyword.type!)
            DispatchQueue.main.async {
                self.existKeywordTable.reloadData()
            }
        }
    }
    @IBAction func ExitButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
