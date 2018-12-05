//
//  BillsItemTableViewCell.swift
//  Roommates
//
//  Created by Sarah Ericson on 12/4/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillsItemTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField:UITextField!
    weak var billItem:BillItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        billItem.title = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}

