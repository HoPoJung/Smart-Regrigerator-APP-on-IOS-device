//
//  FoodNameViewController.swift
//  SmartRefrigeratorApp
//
//  Created by 何柏融 on 2017/3/21.
//  Copyright © 2017年 Peter. All rights reserved.
//

import UIKit
import RealmSwift

class FoodNameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func queryFoodName() -> Any {
        let realm = try! Realm()
        let food = realm.objects(Food.self)
        return food
    }
    @IBOutlet weak var foodName_1: UIButton!
    @IBOutlet weak var foodName_2: UIButton!
    @IBOutlet weak var foodName_3: UIButton!
    @IBOutlet weak var foodName_4: UIButton!
    @IBOutlet weak var foodName_5: UIButton!
    @IBOutlet weak var foodName_6: UIButton!
    @IBOutlet weak var foodName_7: UIButton!
    @IBOutlet weak var foodName_8: UIButton!
    func changeButtonFoodName() {
        let realm = try! Realm()
        let food = realm.objects(Food.self)
        foodName_1.setTitle(food[0].foodName, for: .normal)
        foodName_2.setTitle(food[1].foodName, for: .normal)
        foodName_3.setTitle(food[2].foodName, for: .normal)
        foodName_4.setTitle(food[3].foodName, for: .normal)
        foodName_5.setTitle(food[4].foodName, for: .normal)
        foodName_6.setTitle(food[5].foodName, for: .normal)
        foodName_7.setTitle(food[6].foodName, for: .normal)
        foodName_8.setTitle(food[7].foodName, for: .normal)
        
    }

}
