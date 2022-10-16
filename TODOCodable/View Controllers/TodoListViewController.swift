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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let newItem = Item()
        newItem.title = "Dodgers"
        newItem.date = "1/1/22"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Yankees"
        newItem2.date = "2/2/22"
        itemArray.append(newItem2)
        
        loadItems()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoListCell
        cell.mainLabel.text = itemArray[indexPath.row].title
        cell.mainLabel.numberOfLines = 3
        cell.dateLabel.text = itemArray[indexPath.row].date
        //cell.textLabel?.text = itemArray[indexPath.row].title
        //cell.textLabel?.numberOfLines = 3
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row].title)
        
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goTodoDetail", sender: self)
        
    }

    @IBAction func addButton(_ sender: UIBarButtonItem) {
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

}

