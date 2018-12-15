//
//  ListItemDetailViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/30/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ListItemDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField:UITextField!
    @IBOutlet weak var notesTextView:UITextView!
    @IBOutlet weak var completedSwitch:UISwitch!
    @IBOutlet weak var selectedDate:UILabel!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var dueDate:UILabel!
    weak var listTVC:ListTableViewController?
    weak var listItem:ListItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 1)
        notesTextView.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 1)
        dueDate.layer.addBorder(edge: UIRectEdge.left, color: UIColor.lightGray, thickness: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        datePicker.isHidden = true;
        if let item = listItem {
            navigationItem.title = item.title
            titleTextField.text = item.title
            if item.dueDate != nil {
                dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
                print("This is the item.date = " + dateFormatter.string(from: item.dueDate!))
                selectedDate.text = dateFormatter.string(from: item.dueDate!)
                selectedDate.textColor = UIColor.white
                selectedDate.isHidden = false
            }
            if item.notes != nil {
                notesTextView.text = item.notes
                notesTextView.textColor = UIColor.black
            }
            completedSwitch.isOn = item.isCompleted
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let item = listItem {
            item.title = titleTextField.text!
            if notesTextView.text != "Item Notes" && notesTextView.text != "" {
                item.notes = notesTextView.text
            }
            if item.dueDate == nil && selectedDate.text != "None" {
                item.dueDate = datePicker.date
                print("setting item.date")
            }
            item.isCompleted = completedSwitch.isOn
        
            // get ToDoItems from CoreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            var fetchResults:[Any] = []
            
            let fetchRequest:NSFetchRequest = NSFetchRequest<ListItem>(entityName: "ListItem")
            let sortByName:NSSortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
            fetchRequest.sortDescriptors = [sortByName]
            do {
                fetchResults = try context.fetch(fetchRequest)
                listTVC!.listItems = NSMutableArray(array: fetchResults) as! [ListItem]
            } catch {
                print("Error executing fetch request with request: \(fetchRequest)")
            }
            
        }

    }
    
    @IBAction func screenTapped() {
        view.endEditing(true)
        datePicker.isHidden = true
    }
    
    @IBAction func datePickerLabelTapped() {
        if (!datePicker.isHidden) {
            screenTapped()
        } else {
            datePicker.isHidden = false
            datePicker.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func datePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
        let strDate = dateFormatter.string(from: datePicker.date)
        selectedDate.text = strDate
        selectedDate.textColor = UIColor.white
    }
    
    // MARK: - Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - Text View
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.text == "Item Notes" {
            notesTextView.text = ""
            notesTextView.textColor = UIColor.white
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension CALayer {
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: thickness)
            
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.bounds.height - thickness,  width: self.bounds.width, height: thickness)
            
        // using this as a special case for bottom, this isn't really the left
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: self.bounds.height - thickness + 10,  width: UIScreen.main.bounds.width - 30, height: thickness)
            
        case UIRectEdge.right:
            border.frame = CGRect(x: self.bounds.width - thickness, y: 0,  width: thickness, height: self.bounds.height)
        default:
            break
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}

