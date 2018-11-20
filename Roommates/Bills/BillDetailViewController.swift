//
//  BillDetailViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var whatsItFor:UITextField!
    @IBOutlet weak var payToPerson:UITextField!
    @IBOutlet weak var isPaid:UISwitch!
    @IBOutlet weak var datePicker:UIDatePicker!
    @IBOutlet weak var amount:UITextField!
    @IBOutlet weak var dueDate:UILabel!
    @IBOutlet weak var navigationBar:UINavigationBar!
    var delegate:BillsAddEditDelegate?
    
    weak var bill:BillItem?
    var newBill:BillItem?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    // MARK: -PackersAddEditPlayerDelegate
    func cancelAddEditPlayer() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveAddEditPlayer(_ bill: BillItem) {
        dismiss(animated: true, completion: nil)
    }
    
//    @IBAction func cancelTapped() {
//        delegate?.cancelAddEditBill()
//    }
//    
//    @IBAction func saveTapped() {
//        if let bill = bill { // edit
//            bill.title = whatsItFor.text!
//            bill.payToPerson = payToPerson.text!
//            bill.isPaid = isPaid.isOn
//            bill.amount = Double(amount.text!)!
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let date = dateFormatter.date(from: dueDate!.text!)
//            bill.dueDate = date
//        } else { // add
//            newBill!.title = whatsItFor.text!
//            newBill!.payToPerson = payToPerson.text!
//            newBill!.isPaid = isPaid.isOn
//            newBill!.amount = Double(amount.text!)!
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let date = dateFormatter.date(from: dueDate!.text!)
//            newBill!.dueDate = date
//            bill = newBill
//        }
//        delegate?.saveAddEditBill(bill!)
//    }

    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        datePicker.isHidden = true;
        if let item = bill {
            navigationItem.title = item.title
            whatsItFor.text = item.title
            payToPerson.text = item.payToPerson
            isPaid.isOn = item.isPaid
            if let amountPaid = Double(amount.text!) {
                amount.text = String(amountPaid)
            }
            
            if item.dueDate != nil {
                dateFormatter.dateFormat = "MMMM d 'at' h:mm a"
                print("This is the item.date = " + dateFormatter.string(from: item.dueDate!))
                dueDate.text = dateFormatter.string(from: item.dueDate!)
                dueDate.textColor = UIColor.black
                dueDate.isHidden = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let item = bill {
            item.title = whatsItFor.text!
            if payToPerson.text != "Name" && payToPerson.text != "" {
                item.payToPerson = payToPerson.text!
            }
            if Double(amount.text!) != 0.00 && amount.text != nil {
                item.amount = Double(amount.text!)!
            }
            if item.dueDate == nil && dueDate.text != "None" {
                item.dueDate = datePicker.date
            }
            
            item.isPaid = isPaid.isOn
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
