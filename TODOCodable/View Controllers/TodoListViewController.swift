//
//  ViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit

var itemArray = [Item()]
let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathExtension("Items.plist")

class TodoListViewController: UITableViewController {
    
    var itemSelected = Item()
    var itemSelectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let newItem = Item()
//        newItem.title = "Dodgers"
//        newItem.description = "YOYOYO"
//        newItem.date = "1/1/22"
//        itemArray.append(newItem)
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoListCell
        cell.mainLabel.text = itemArray[indexPath.row].title
        cell.detailLabel.text = itemArray[indexPath.row].description
        cell.detailLabel.numberOfLines = 2
        cell.dateLabel.text = itemArray[indexPath.row].date + itemArray[indexPath.row].time
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected = itemArray[indexPath.row]
        itemSelectedIndex = indexPath.row
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goTodoDetail", sender: self)
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
    }
    
    func createNewItem(title: String, description: String) {
        let currentDate = dateFormatter()
        
        let newItem = Item()
        newItem.title = title
        newItem.description = description
        newItem.done = false
        newItem.date = currentDate[0]
        newItem.time = currentDate[1]
        itemArray.append(newItem)
        
        saveItems()
    }
    
    func dateFormatter() -> [String] {
        let currentDate =  Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle     = .short
        dateFormatter.timeStyle     = .short
        dateFormatter.locale        = Locale(identifier: "en_US")
        let newDate = dateFormatter.string(from: currentDate).components(separatedBy: ",")
        
        return newDate
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array\(error)")
        }
        
    }
    
    func editItem(title: String, desc: String) {
        let currentDate = dateFormatter()
        itemArray[itemSelectedIndex].title = title
        itemArray[itemSelectedIndex].description = desc
        itemArray[itemSelectedIndex].date = currentDate[0]
        itemArray[itemSelectedIndex].time = currentDate[1]
        
        let itemMoved = itemArray.remove(at: itemSelectedIndex)
        itemArray.insert(itemMoved, at: 0)
        //itemArray[itemSelectedIndex]
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemArray\(error)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goTodoDetail" {
            let destinationVC = segue.destination as! TodoDetailViewController
            destinationVC.itemSelectedTodoList = itemSelected
            print("Hello", itemSelected)
            //destinationVC.detailsTextView.text = itemSelected
        }
        
    }
    
    @IBAction func unwindTodoListViewController(unwindSegue: UIStoryboardSegue) {
    }
    //use viewWillApear for ipad

}

