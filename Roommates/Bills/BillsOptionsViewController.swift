//
//  SecondViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/28/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillsOptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    // this needs to be switched to use the way that we did it in the packer app with present modally, not segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination
        // Pass the selected object to the new view controller.
        if segue.identifier == "paySomeoneSegue" {
            if let destinationVC = segue.destination as? BillsTableViewController {
                destinationVC.navigationItem.title = "Pay Someone"
            }
        } else if segue.identifier == "getPaidSegue" {
            if let destinationVC = segue.destination as? BillsTableViewController {
                destinationVC.navigationItem.title = "Get Paid"
            }
        }
    }

}

