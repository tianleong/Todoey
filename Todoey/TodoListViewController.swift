//
//  ViewController.swift
//  Todoey
//
//  Created by Tian Xiang Leong on 7/05/19.
//  Copyright © 2019 Tian Xiang Leong. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    let itemArray = ["Find Mike", "Buy Eggs", "Read book"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    //MARK:  Tableview Datasource Methods
    //1. How many rows we want in tableview.
    //2. Specify what cells should display.
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        //set the text label
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    //To get the todo item ticked when table cell touched and unticked when touched again.
    //Detects which row is selected.
    //Checks whether selected row has a checkmark. If it does, it'll remove checkmark. If it doesn't, it'll add checkmark.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
     //to add and remove checkmark when clicked
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //UI improvement: make the cell deselect immediately
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    
    
}

