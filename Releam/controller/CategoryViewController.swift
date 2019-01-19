//
//  CategoryViewController.swift
//  Releam
//
//  Created by Mohamed Elsayed on 1/11/19.
//  Copyright © 2019 Sayedovic. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var Catego: Results<Category>?

    //MARK: - view didload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategory()
        
    }
    //MARK: - table properties
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Catego?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = Catego?[indexPath.row].name ?? "No Category add yet!"
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //this commented line below costed me two weeks to realise that deselecting row didn't manage me to have a value to indexpath :)
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ToCategoryVC", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            let selectedrow = indexPath.row
            destinationVC.selectedCategory = Catego?[selectedrow]
        }else{
            print("%^&the preparation segue not performed")
        }
    }
    //Delete cells
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            // delete item at indexPath
            if let categ = self.Catego?[indexPath.row]{
                do{
                    try self.realm.write {
                        self.realm.delete(categ)
                    }
                }catch{
                    print(error)
                }
            }
            tableView.reloadData()
        }
        return [delete]
    }
    
    @IBAction func AddCategory(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add category In the List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCatego = Category()
            newCatego.name = textfield.text!
            self.saveCategory(Category: newCatego)
            self.tableView.reloadData()
        }
        alert.addTextField { (field) in
            field.placeholder = "Add Category"
            textfield = field
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - save and load data using core data method
    func saveCategory(Category: Category){
        
        do{
            try realm.write {
                realm.add(Category)
            }
        }catch{
            print("error in saving context(Category): \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategory() {
        Catego = realm.objects(Category.self)
        self.tableView.reloadData()
    }
}
