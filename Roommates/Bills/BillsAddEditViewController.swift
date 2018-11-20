//
//  BillsAddEditViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillsAddEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var whatsItFor:UITextField!
    @IBOutlet weak var payToPerson:UITextField!
    @IBOutlet weak var isPaid:UISwitch!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var amount:UITextField!
    @IBOutlet weak var dueDate:UILabel!
    @IBOutlet weak var navigationBar:UINavigationBar!
    weak var bill:BillItem?
    var delegate:BillsAddEditDelegate?
    var newBill:BillItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let bill = bill { //the bill exists; edit bill
            navigationBar.topItem?.title = "Edit Bill"
            whatsItFor.text = bill.title
            payToPerson.text = bill.payToPerson
            isPaid.isOn = bill.isPaid
            amount.text = String(bill.amount)
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dueDate.text = formatter.string(from: bill.dueDate!)
        } else { //the player doesn't exist; add player
            navigationBar.topItem?.title = "Create Bill"
        }
    }
    
    @IBAction func cancelTapped() {
        delegate?.cancelAddEditBill()
    }
    
    @IBAction func saveTapped() {
        if let bill = bill { // edit
            bill.title = whatsItFor.text!
            bill.payToPerson = payToPerson.text!
            bill.isPaid = isPaid.isOn
            bill.amount = Double(amount.text!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: dueDate!.text!)
            bill.dueDate = date
        } else { // add
            newBill!.title = whatsItFor.text!
            newBill!.payToPerson = payToPerson.text!
            newBill!.isPaid = isPaid.isOn
            newBill!.amount = Double(amount.text!)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: dueDate!.text!)
            newBill!.dueDate = date
            bill = newBill
        }
        delegate?.saveAddEditBill(bill!)
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
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
