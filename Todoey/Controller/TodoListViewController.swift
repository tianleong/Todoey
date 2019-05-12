//
//  ViewController.swift
//  Todoey
//
//  Created by Tian Xiang Leong on 7/05/19.
//  Copyright © 2019 Tian Xiang Leong. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        } //these actions will happen as soon as selectedCategory gets set with a value.
    }
    
  
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //(Get access to AppDelegate as an Object)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
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
    
    //didSelectRow - what happens when you click on a Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //sets done property on current item in the array to the opposite of what it is now
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        //to Delete items - order is important!
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        
        
        //to save checkmark to Items.plist
        saveItems()
        
        //UI improvement: make the cell deselect immediately
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    //MARK: Add new to-do items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //what will happen once user clicks "add item" button on UIAlert
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Model Manipulation Methods
    
    func saveItems() {

        do {
           try context.save()
        } catch {
           print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        
        //to show Todo Items that match the selected Category
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        //optional binding - make sure never unwrapping nil value.
        //if the predicate passed in isn't nil, then the additionalPredicate is the categoryPredicate and the new predicate passed in
        //if the predicate passed in is nil, the predicate is simply the categoryPredicate. 
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate!])
//        // [categoryPredicate , predicate ---> ARGUMENT PASSED IN AT TOP ]
//
//
//        request.predicate = compoundPredicate
        
        do {
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: Search bar methods

extension TodoListViewController: UISearchBarDelegate {
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //to test code
        //print(searchBar.text!)
        
        //to query objects using Core Data:
        //we adjust the nature of the request:
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //show items containing text typed
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] //sort in alphabetical order
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            //to remove cursor in search bar and keyboard. this process happens in the foreground.
            DispatchQueue.main.async {
            searchBar.resignFirstResponder()
            }
           
        }
        
    }
    
    
}
