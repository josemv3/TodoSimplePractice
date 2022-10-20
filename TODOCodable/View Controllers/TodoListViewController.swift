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
    
    private let realm = try! Realm()
    //Do, Catch, Try in AppDelegate. Docs say after initial unwrap Realm call wont fail.
    //Force unwrap is safe.
    private var todoItems: Results<Item>?
    var itemSelectedIndex = 0
    private var openDoneToggleSelected = "open"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - TableView swipe action
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = UIContextualAction(style: .destructive, title: "Complete!") { _, _, _ in
            
            if self.openDoneToggleSelected == "open" {
                tableView.beginUpdates()
                let todoToUpdate = self.todoItems?[indexPath.row]
                try! self.realm.write {
                    todoToUpdate?.done = true
                }
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
            }
        }
        complete.backgroundColor = .systemGreen
        let swipe = UISwipeActionsConfiguration(actions: [complete])
        return swipe
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoListCell
        
        if let item = todoItems?[indexPath.row] {
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
        itemSelectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goTodoDetail", sender: self)
    }
    
    //MARK: - Item CRUD to Realm (persist data)
    
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
    
    private func loadItems() {
        let completed = openDoneToggleSelected == "done"
        todoItems = realm.objects(Item.self).where {
            $0.done == completed
        }.sorted(byKeyPath: "dateActual", ascending: false)
    }
    
    func editItem(title: String, desc: String, status: Bool) {
        let todoToUpdate = todoItems?[itemSelectedIndex]
        
        do{
            try realm.write {
                todoToUpdate?.title = title
                todoToUpdate?.desc = desc
                todoToUpdate?.done = status
                todoToUpdate?.dateActual = Date()
                let currentDate = dateFormatter(itemDate: todoToUpdate?.dateActual ?? Date())
                todoToUpdate?.date = currentDate[0]
                todoToUpdate?.time = currentDate[1]
            }
        } catch {
            print("Error encoding item array\(error)")
        }
            
    }
    
    //MARK: - Segmented controller
    
    @IBAction func openDoneToggleTap(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            openDoneToggleSelected = "open"
        } else {
            openDoneToggleSelected = "done"
        }
        loadItems()
        tableView.reloadData()
    }
    
    func dateFormatter(itemDate: Date) -> [String] { //Could move to utilities file
        let currentDate =  itemDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle     = .short
        dateFormatter.timeStyle     = .short
        dateFormatter.locale        = Locale(identifier: "en_US")
        let newDate = dateFormatter.string(from: currentDate).components(separatedBy: ",")
        return newDate
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTodoDetail" {
            guard let item = todoItems?[itemSelectedIndex] else {
                fatalError("No active item")
            }
            let destinationVC = segue.destination as! TodoDetailViewController
            destinationVC.itemSelectedTodoList = item
            //guard (line -121) replaced todoItems?[itemSelectedIndex] ?? item() - line 125
        }
    }
    
    @IBAction func unwindTodoListViewController(unwindSegue: UIStoryboardSegue) {
    }
}

