//
//  TodoAddViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit
import RealmSwift

class TodoAddViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var todoAddTitleTF: UITextField!
    
    var newTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TODO Add"
        textView.delegate = self
        textView.text = "Tap here to write details..."
        textView.textColor = UIColor.lightGray
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        destinationVC.createNewItem(title: todoAddTitleTF.text ?? "Blank", description: textView.text)
        destinationVC.tableView.reloadData()
    }
    
    @IBAction func cancelBtnTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}




