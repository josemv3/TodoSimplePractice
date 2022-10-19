//
//  TodoDetailViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit

class TodoDetailViewController: UIViewController {
    
    @IBOutlet weak var todoDetailsTitleTF: UITextField!
    @IBOutlet weak var todoDetailsTV: UITextView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var changeBtn: UIBarButtonItem!
    
    var itemSelectedTodoList = Item()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TODO Details"
        
        changeBtn.isEnabled = false
        todoDetailsTV.isEditable = false
        todoDetailsTitleTF.isUserInteractionEnabled = false
        todoDetailsTitleTF.text = itemSelectedTodoList.title
        todoDetailsTV.text = itemSelectedTodoList.desc
    }
    
    @IBAction func editBtnTap(_ sender: UIBarButtonItem) {
        if todoDetailsTV.isEditable == false {
            todoDetailsTV.isEditable = true
            todoDetailsTitleTF.isUserInteractionEnabled = true
            changeBtn.isEnabled = true
        } else {
            todoDetailsTV.isEditable = false
            todoDetailsTitleTF.isUserInteractionEnabled = false
            changeBtn.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.editItem(title: todoDetailsTitleTF.text ?? "", desc: todoDetailsTV.text)
        destinationVC.tableView.reloadData()
    }
    
    
}
