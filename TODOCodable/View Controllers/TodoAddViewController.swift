//
//  TodoAddViewController.swift
//  TODOCodable
//
//  Created by Joey Rubin on 10/15/22.
//

import UIKit

class TodoAddViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "TODO Add"
        textView.delegate = self
        textView.text = "Tap here..."
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
            textView.text = "Tap here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func saveBtnTap(_ sender: UIBarButtonItem) {
        let newItem = Item()
        newItem.title = textView.text
        newItem.done = false
        itemArray.append(newItem)
        
        saveItems()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancelBtnTap(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array\(error)")
            }
        }
    }
    
}

