//
//  CategoryViewController.swift
//  Releam
//
//  Created by Mohamed Elsayed on 1/11/19.
//  Copyright © 2019 Sayedovic. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var Catego = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - table properties
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Catego.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = Catego[indexPath.row].name
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ToCategoryVC", sender: self)
        
        let VC: ToDoListViewController = ToDoListViewController()
        VC.selectedCategory = Catego[indexPath.row]
        print(VC.selectedCategory!.name!)
    
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! ToDoListViewController
//        if let indexPath = tableView.indexPathForSelectedRow{
//            destinationVC.selectedCategory = Catego[indexPath.row]
//            print (destinationVC.selectedCategory!.name!)
//        }
    }
    //MARK: - view didload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
       
    }

    @IBAction func AddCategory(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add category In the List", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCatego = Category(context: self.context)
            newCatego.name = textfield.text!
            self.Catego.append(newCatego)
            self.saveCategory()
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
    func saveCategory(){
        
        do{
            try context.save()
        }catch{
            print("error in saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        //let request : NSFetchRequest<Item>=Item.fetchRequest()
        do{
            Catego = try context.fetch(request)
        } catch{
            print("error in fetching data : \(error)")
        }
        self.tableView.reloadData()
        
    }
    
}
    


