//
//  BillDetailViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillDetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, BillsAddEditDelegate {
    
    @IBOutlet weak var whatsItFor:UILabel!
    @IBOutlet weak var payToPerson:UILabel!
    @IBOutlet weak var isPaid:UILabel!
    @IBOutlet weak var amount:UILabel!
    @IBOutlet weak var dueDate:UILabel!
    var addEditDelegate:BillsAddEditDelegate?
    var billsTableViewDelegate:ClassBTVDelegate?
    weak var bill:BillItem?
    var newBill:BillItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatter = DateFormatter()
        if let item = bill {
            whatsItFor.text = item.title
            payToPerson.text = item.payToPerson
            if item.isPaid {
                isPaid.text = "Is paid"
            } else {
                isPaid.text = "Is not paid"
            }
            amount.text = "$" + String(item.amount)
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
    

    // MARK: -BillsAddEditDelegate
    func cancelAddEditBill() {
        dismiss(animated: true, completion: nil)
    }
    
    func saveAddEditBill(_ billItem: BillItem) {
        dismiss(animated: true, completion: nil)
        bill = billItem
        viewWillAppear(true)
    }
    
    
    // MARK: - Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if segue.identifier == "addEditBillSegue" {
            if let addEditBillVC = segue.destination as? BillsAddEditViewController {
                addEditBillVC.bill = bill
                addEditBillVC.addEditDelegate = self
                addEditBillVC.billsTableViewDelegate = self.billsTableViewDelegate
            }
        }
     }
 
    
}
