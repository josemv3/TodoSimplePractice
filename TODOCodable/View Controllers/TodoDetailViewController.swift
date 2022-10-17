//
//  TodoDetailViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit

class TodoDetailViewController: UIViewController {
 
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    var itemSelectedTodoList = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TODO Details"
        detailsTextView.text = itemSelectedTodoList
        detailsTextView.isEditable = false
    }
    
    @IBAction func editBtnTap(_ sender: UIBarButtonItem) {
        if editBtn.title == "Edit" {
            editBtn.title = "Complete"
            detailsTextView.isEditable = true
        } else {
            navigationController?.popViewController(animated: true)
            editBtn.title = "Edit"
        }
    }

}
