//
//  ViewController.swift
//  TODO
//
//  Created by José Antonio Fernández Sandá on 08/01/2019.
//  Copyright © 2019 José Antonio Fernández Sandá. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray: [TodoItem] = [TodoItem]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }

    //MARK - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item =  itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark: .none
        return cell
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items

    @IBAction func addButtomItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default){
            (action) in
            self.itemArray.append(TodoItem(textField.text!,false))
            self.saveItems()
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Add new items
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("Error encoding!, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        do {
            if let data = try? Data(contentsOf: dataFilePath!){
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([TodoItem].self, from: data)
            }
        }catch{
            print("Error dencoding!, \(error)")
        }
    }
}

