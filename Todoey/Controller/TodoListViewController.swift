//
//  ViewController.swift
//  Todoey
//
//  Created by Tian Xiang Leong on 7/05/19.
//  Copyright © 2019 Tian Xiang Leong. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    //Data Persistence User Defaults Step 1
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggs"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Read book"
        itemArray.append(newItem3)
        
        //Data Persistence User Defaults Step 4
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            itemArray = items
        }

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
        
        let item = itemArray[indexPath.row]
        
        //set the text label
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    //To get the todo item ticked when table cell touched and unticked when touched again.
    //Detects which row is selected.
    //Checks whether selected row has a checkmark. If it does, it'll remove checkmark. If it doesn't, it'll add checkmark.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        //sets done property on current item in the array to the opposite of what it is now
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //forces tableview to call its datasource methods again. it reloads data that's meant to be inside
        tableView.reloadData()
        
        //UI improvement: make the cell deselect immediately
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: Add new to-do items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once user clicks "add item" button on UIAlert
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            //Data Persistence User Defaults Step 2
            self.defaults.set(self.itemArray, forKey: "TodoListArray")

            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
}

