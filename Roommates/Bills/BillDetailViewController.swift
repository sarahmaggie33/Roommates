//
//  BillDetailViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var whatsItFor:UILabel!
    @IBOutlet weak var payToPerson:UILabel!
    @IBOutlet weak var isPaid:UISwitch!
    @IBOutlet weak var amount:UILabel!
    @IBOutlet weak var dueDate:UILabel!
    @IBOutlet weak var datePicker:UIDatePicker!

    weak var bill:BillItem?
    var newBill:BillItem?
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        if let item = bill {
            whatsItFor.text = item.title
            payToPerson.text = item.payToPerson
            if item.isPaid {
                isPaid.isOn = item.isPaid
            }
            amount.text = String(item.amount)
            if item.dueDate != nil {
                dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
                dueDate.text = dateFormatter.string(from: item.dueDate!)
                dueDate.textColor = UIColor.black
                dueDate.isHidden = false
            } else {
                dueDate.text = "No due date"
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let bill = bill { // edit
            bill.title = whatsItFor.text!
            bill.payToPerson = payToPerson.text!
            bill.isPaid = isPaid.isOn
            bill.amount = Double(amount.text!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: dueDate!.text!)
            bill.dueDate = date
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
        }
    }
    
    @IBAction func datePickerChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
        let strDate = dateFormatter.string(from: datePicker.date)
        dueDate.text = strDate
        dueDate.textColor = UIColor.black
    }
    
    
    // MARK: - Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
