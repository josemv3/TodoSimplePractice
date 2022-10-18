//
//  ViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit
import RealmSwift


let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")

class TodoListViewController: UITableViewController {
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var todoitemsSorted: Results<Item>?
    
    var itemSelected = Item()
    var itemSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoListCell
        
        if let item = todoitemsSorted?[indexPath.row] {
            cell.mainLabel.text = item.title
            cell.detailLabel.text = item.desc
            cell.detailLabel.numberOfLines = 2
            cell.dateLabel.text = item.date + item.time
        } else {
            cell.mainLabel.text = "No Item Added"
            cell.detailLabel.text = ""
            cell.detailLabel.numberOfLines = 2
            cell.dateLabel.text = ""
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected = todoitemsSorted![indexPath.row]
        itemSelectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goTodoDetail", sender: self)
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
    }
    
    func createNewItem(title: String, description: String) {
        
        
        let newItem = Item()
        newItem.title = title
        newItem.desc = description
        let currentDate = dateFormatter(itemDate: newItem.dateActual)
        newItem.date = currentDate[0]
        newItem.time = currentDate[1]
        //todoItems = realm.objects(Item.self)
        
        do {
            try realm.write {
                realm.add(newItem)
            }
        } catch {
            print("Error encoding item array\(error)")
        }
    }
    
    func dateFormatter(itemDate: Date) -> [String] {
        let currentDate =  itemDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle     = .short
        dateFormatter.timeStyle     = .short
        dateFormatter.locale        = Locale(identifier: "en_US")
        let newDate = dateFormatter.string(from: currentDate).components(separatedBy: ",")
        
        return newDate
    }
    
   func editItem(title: String, desc: String) {
       
       let todoToUpdate = todoitemsSorted![itemSelectedIndex]
       try! realm.write {
           todoToUpdate.title = title
           todoToUpdate.desc = desc
           todoToUpdate.dateActual = Date()
           let currentDate = dateFormatter(itemDate: todoToUpdate.dateActual)
           todoToUpdate.date = currentDate[0]
           todoToUpdate.time = currentDate[1]
       }
       
    }
    
    func loadItems() {
        
        todoItems = realm.objects(Item.self)
        todoitemsSorted = todoItems?.sorted(byKeyPath: "dateActual", ascending: false)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTodoDetail" {
            let destinationVC = segue.destination as! TodoDetailViewController
            destinationVC.itemSelectedTodoList = itemSelected
        }
        
    }
    
    @IBAction func unwindTodoListViewController(unwindSegue: UIStoryboardSegue) {
    }
    //use viewWillApear for ipad

}

