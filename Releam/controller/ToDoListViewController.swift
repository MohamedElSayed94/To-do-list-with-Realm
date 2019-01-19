//
//  ViewController.swift
//  Releam
//
//  Created by Mohamed Elsayed on 11/2/18.
//  Copyright © 2018 Sayedovic. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    //MARK: - initialization of global variables
    var ToDoItems: Results<Items>?

    //MARK: - a way to do something if a certain variables is occupied
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ToDoItems?.count ?? 1
    }
    //MARK: - table properties
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(ToDoItems[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = self.ToDoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel!.text = ToDoItems?[indexPath.row].title ?? "No Items Add Yet !"
        
        if ToDoItems?[indexPath.row].done == true {
            cell.accessoryType = .checkmark
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
            //tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        return cell
        
    }
        override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
                // delete item at indexPath
                if let item = self.ToDoItems?[indexPath.row]{
                    do{
                        try self.realm.write {
                            self.realm.delete(item)
                        }
                    }catch{
                        print(error)
                    }
                }
                tableView.reloadData()
            }
            return [delete]
        }
    
    //MARK: - add buttom
    
    @IBAction func AddBarButtom(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item In the List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // unwrapping  ? optional value
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write{
                        let newitem = Items()
                        newitem.title = textField.text!
                        currentCategory.items.append(newitem)
                        self.tableView.reloadData()
                    }
                }catch{
                    print("error in saving Items: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (AlertTextField) in
            AlertTextField.placeholder = "Add Item"
            textField = AlertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func loadItems() {
        
        ToDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        self.tableView.reloadData()
    }
}
//MARK: - search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    // if the text field has no text it gives us the original list of items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        ToDoItems = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title")
        self.tableView.reloadData()
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
          }
        }
    }
}
