//
//  ViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var openDoneToggle: UIBarButtonItem!
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var todoitemsSorted: Results<Item>?
    var itemSelected = Item()
    var itemSelectedIndex = 0
    var openDoneToggleSelected = "open"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let complete = UIContextualAction(style: .destructive, title: "Complete!") { _, _, _ in
            
            if self.openDoneToggleSelected == "open" {
                tableView.beginUpdates()
                let todoToUpdate = self.todoitemsSorted![indexPath.row]
                try! self.realm.write {
                    todoToUpdate.done = true
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
        
        complete.backgroundColor = .systemGreen
        let swipe = UISwipeActionsConfiguration(actions: [complete])
        return swipe
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
    
    func createNewItem(title: String, description: String) {
        
        let newItem = Item()
        newItem.title = title
        newItem.desc = description
        let currentDate = dateFormatter(itemDate: newItem.dateActual)
        newItem.date = currentDate[0]
        newItem.time = currentDate[1]
        
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
        
        if openDoneToggleSelected == "open" {
            todoItems = realm.objects(Item.self).where {
                $0.done == false
            }
            todoitemsSorted = todoItems?.sorted(
                byKeyPath: "dateActual", ascending: false)
            
        } else if openDoneToggleSelected == "done" {
            
            todoItems = realm.objects(Item.self).where {
                $0.done == true
            }
            todoitemsSorted = todoItems?.sorted(
                byKeyPath: "dateActual", ascending: false)
        }
    }
    
    func deleteItem(item: Item) { //Not used yet
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error encoding item array\(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTodoDetail" {
            let destinationVC = segue.destination as! TodoDetailViewController
            destinationVC.itemSelectedTodoList = itemSelected
        }
    }
    
    @IBAction func openDoneToggleTap(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            openDoneToggleSelected = "open"
        } else {
            openDoneToggleSelected = "done"
        }
        loadItems()
        tableView.reloadData()
    }
    
    @IBAction func unwindTodoListViewController(unwindSegue: UIStoryboardSegue) {
    }
    //use viewWillApear for ipad
    
}

