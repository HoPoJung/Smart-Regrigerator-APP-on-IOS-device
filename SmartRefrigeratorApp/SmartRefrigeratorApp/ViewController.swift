//
//  ViewController.swift
//  SmartRefrigeratorApp
//
//  Created by 何柏融 on 2017/2/6.
//  Copyright © 2017年 Peter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {

    var foodListContent = ["apple", "meat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3//foodListContent.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtindexPath indexPath: NSIndexPath) -> UITableViewCell{
    
        let Cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "foodCell")
        Cell.textLabel?.text = "test"
        return Cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

