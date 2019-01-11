//
//  ViewController.swift
//  Releam
//
//  Created by Mohamed Elsayed on 11/2/18.
//  Copyright © 2018 Sayedovic. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController {

    //MARK: - initialization of global variables
    var arr = [Item]()
    //let defualts = UserDefaults.standard
    var checkmarks = [Int:Bool]()
    var selectedCategory: Category?{
        didSet{
            loadItems()
        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //loadItems()
       
        if let checks = UserDefaults.standard.value(forKey: "checkmarks") as? NSData {
            checkmarks = NSKeyedUnarchiver.unarchiveObject(with: checks as Data) as! [Int : Bool]
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
   
    
   //MARK: - table properties
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(arr[indexPath.row])
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                checkmarks[indexPath.row] = false
            }
            else{
                cell.accessoryType = .checkmark
                checkmarks[indexPath.row] = true
            }
        }
//        if arr[indexPath.row].done == true {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            arr[indexPath.row].done = false
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            arr[indexPath.row].done = true
//        }
//        self.context.delete(self.arr[indexPath.row])
//        self.arr.remove(at: indexPath.row)
        self.saveItems()
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = arr[indexPath.row].title
        
        tableView.deselectRow(at: indexPath, animated: true)
//        if arr[indexPath.row].done == true {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            print("checkmark")
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            print("none")
//        }
        if checkmarks[indexPath.row] != nil {
            cell.accessoryType = checkmarks[indexPath.row]! ? .checkmark : .none
        } else {
            checkmarks[indexPath.row] = false
            cell.accessoryType = .none
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: checkmarks), forKey: "checkmarks")
        UserDefaults.standard.synchronize()
        return cell
        
    }
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            // delete item at indexPath
            
            self.context.delete(self.arr[indexPath.row])
            self.arr.remove(at: indexPath.row)
            self.saveItems()
        }
        return [delete]
    }

//MARK: - add buttom
    
    @IBAction func AddBarButtom(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add Item In the List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newitem = Item(context: self.context)
            newitem.title = textField.text!
            //newitem.done = false
            newitem.parentcategory = self.selectedCategory
            self.arr.append(newitem)
            self.saveItems()
            //self.tableView.reloadData()
            print(newitem.parentcategory!)
            
        }
        alert.addTextField { (AlertTextField) in
            AlertTextField.placeholder = "Add Item"
            textField = AlertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
//MARK: - save and load data using core data method
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("error in saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentcategory.name MATCHES %@ ",selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        //let request : NSFetchRequest<Item>=Item.fetchRequest()
        do{
          arr = try context.fetch(request)
        } catch{
            print("error in fetching data : \(error)")
        }
        self.tableView.reloadData()
    
    }

}
//MARK: - search bar methods
extension ToDoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@",searchBar.text!)
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,predicate: predicate)

        
    // if the text field has no text it gives us the original list of items
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.count == 0 {
            loadItems()
            DispatchQueue.main.async {
               searchBar.resignFirstResponder()
          }
        }
        
    }
}
}
