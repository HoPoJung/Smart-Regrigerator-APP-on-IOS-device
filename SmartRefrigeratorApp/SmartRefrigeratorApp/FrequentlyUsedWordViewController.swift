//
//  FrequentlyUsedWordViewController.swift
//  SmartRefrigeratorApp
//
//  Created by Yuan-Pu Hsu on 12/03/2017.
//  Copyright © 2017 Peter. All rights reserved.
//

import UIKit
import RealmSwift

class FrequentlyUsedWordViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var typePicker: UIPickerView!
    
    let typePickerData = ["Food", "Unit"]
    
    var newDataName: String?
    var newDataType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        typePicker.dataSource = self
        typePicker.delegate = self
        keywordTextField.delegate = self
        
    }

    @IBAction func AddButton(_ sender: Any) {
        if (keywordTextField.text != "") {
            newDataName = keywordTextField.text
            keywordTextField.text = ""
            debugPrint("Add new keyword: \(newDataName)")
        }
    }
    @IBAction func ExitButton(_ sender: Any) {
        
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
        self.newDataType = typePickerData[row]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keywordTextField.resignFirstResponder()
        return false
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
