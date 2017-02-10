//
//  ViewController.swift
//  SmartRefrigeratorApp
//
//  Created by 何柏融 on 2017/2/6.
//  Copyright © 2017年 Peter. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var foodListTableView: UITableView!
    var foodListContent = ["apple", "meat"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = UITableView()
        view.addSubview(tableView)
        self.foodListTableView = tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return foodListContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
    
        let Cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "foodCell")
        Cell.textLabel?.text = foodListContent[indexPath.row]
        return Cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

