//
//  TodoDetailViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit

class TodoDetailViewController: UIViewController {
 
    @IBOutlet weak var editBtn: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "TODO Details"
    }
    
    @IBAction func editBtnTap(_ sender: UIBarButtonItem) {
        if editBtn.title == "Edit" {
            editBtn.title = "Complete"
        } else {
            navigationController?.popViewController(animated: true)
            editBtn.title = "Edit"
        }
    }
    

}
