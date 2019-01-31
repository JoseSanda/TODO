//
//  ViewController.swift
//  TODO
//
//  Created by José Antonio Fernández Sandá on 08/01/2019.
//  Copyright © 2019 José Antonio Fernández Sandá. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let realm = try! Realm()
    var items: Results<Item>?
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colourHex = selectedCategory?.colour else {fatalError()}
        title = selectedCategory?.name
        updateNavBar(withHexCode: colourHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK - Navbar setup
    
    func updateNavBar(withHexCode colourHexCode: String){
        guard let navBar = navigationController?.navigationBar else{fatalError("Navigationbar not exits")}
        guard let colour = UIColor(hexString: colourHexCode) else {fatalError()}
        navBar.barTintColor = colour
        navBar.tintColor = ContrastColorOf(colour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(colour, returnFlat: true)]
        searchBar.barTintColor = colour
    }

    //MARK - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let colour = UIColor(hexString: selectedCategory!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(items!.count)) {
                cell.backgroundColor = colour
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: colour, isFlat: true)
            }
        }else {
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try self.realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving new items \(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items

    @IBAction func addButtomItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default){
            (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        currentCategory.items.append(item)
                    }
                }catch{
                    print("Error saving new items \(error)")
                }
            }
            self.tableView.reloadData()
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Add new items
    
    func saveItems(_ item: Item){
        do {
            try realm.write {
                realm.add(item)
            }
        } catch{
            print("Error saving context!, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK - Delete items
    override func delete(_ indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            }catch {
                print("Error on item delete \(error)")
            }
        }
    }
}
//MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

