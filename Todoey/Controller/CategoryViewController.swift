//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tian Xiang Leong on 11/05/19.
//  Copyright © 2019 Tian Xiang Leong. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    //initialising an access point to Realm database.
    let realm = try! Realm()
    
    
    var categories : Results<Category>?
    //a collection of Results that are Category objects.
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    //(Get access to AppDelegate as an Object)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    
    }

    
    //MARK: Tableview Datasource Methods
    //Display all categories in persistent container
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        //categories is an optional and it could be nil.
        //if it's not nil, get the count of the categories and..
        //if it's nil, return 1 instead.
        // ?? = Nil Coalescing Operator
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //set the text label
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        //if categories is not nil, grab the name at indexPath.row
        //if it's nil, just show the "No Cat..." text.
        
        return cell
    }
    
    //MARK: Tableview Delegate Methods
    
    //will trigger when we select a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //to show Items related to the selected Category
    //will be trigerred just before segueway performed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        //grab Category that corresponds to the selected cell
        //identifies current row selected
        //use "if" because indexPathForSelectedRow is an optional
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
            //selectedCategory created in TodoListVC
            
        }
        
    }
    
    //MARK: Data Manipulation Methods
    //save and load data.
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
                }
            //to commit data in context to persistent container
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        //calls Tableview data source methods
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        //pulls out all items inside realm that are Category objects

        
        //Core data code:
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
        
        tableView.reloadData()
    }
    
    
    
    
    //MARK: Add new categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //what will happen once user clicks "add category" button on UIAlert
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
 
    
    

    
    
    
    
    
    
    
    
    
    
}
