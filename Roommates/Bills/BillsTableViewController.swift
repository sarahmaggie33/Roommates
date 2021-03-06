//
//  BillsTableViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

// TODO: Create a class identical to this to keep the pay to and get paid bills
// separate. Otherwise, use sections within the tableview to break it up
// reconfigure addedit to send data back to the proper place.

import UIKit

class BillsGetPaidTableViewController: UITableViewController, ClassBTVDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    var billItems:[BillItem] = []
    weak var delegate: ClassBTVDelegate?
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.reloadData()
    }
    
    func saveToTableView(_ bill: BillItem) {
        billItems.append(bill)
        print("Saved to table view")
    }

    @IBAction func addBill() {
        billItems.insert(BillItem(), at: 0)
        tableView.insertRows(at: [IndexPath(row:0, section:0)], with: UITableView.RowAnimation.top)
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath)

        // Configure the cell...
        let bill = billItems[indexPath.row]
        cell.textLabel!.text = bill.title
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            billItems.remove(at: indexPath.row)
            // Delete the row from the TableView
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    // this needs to be switched to use the way that we did it in the packer app with present modally, not segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailSegue" {
            if let destinationVC = segue.destination as?  BillDetailViewController {
                destinationVC.bill = billItems[tableView.indexPathForSelectedRow!.row]
                if let cell = sender as? UITableViewCell {
                    destinationVC.navigationItem.title = cell.textLabel!.text!
                }
                destinationVC.billsTableViewDelegate = self
            }
        }
    }
}
