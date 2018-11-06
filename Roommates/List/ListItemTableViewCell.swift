//
//  ListItemTableViewCell.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/30/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class ListItemTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField:UITextField!
    weak var listItem:ListItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        listItem.title = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
}
