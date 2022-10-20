//
//  TodoAddViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit
import RealmSwift

class TodoAddViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var todoAddTextView: UITextView!
    @IBOutlet weak var todoAddTitleTextField: UITextField!
    
    private var newTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "New"
        todoAddTextView.delegate = self
        todoAddTextView.text = "Tap here to write details..."
        todoAddTextView.textColor = UIColor.lightGray
    }
    
    //MARK: - Prepare user with placholder text
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tap here to write details..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //MARK: - Segue/Dismiss
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.createNewItem(title: todoAddTitleTextField.text ?? "Blank", description: todoAddTextView.text)
        destinationVC.tableView.reloadData()
    }
    
    @IBAction func cancelBtnTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}




