//
//  ListTableViewController.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/30/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var listItems:[ListItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    @IBAction func addToDoListItem() {
        listItems.insert(ListItem(), at: 0)
        tableView.insertRows(at: [IndexPath(row:0, section:0)], with: UITableView.RowAnimation.top)
    }
    
    @IBAction func editToDoListItem() {
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItemCell", for: indexPath)
        
        // Configure the cell...
        if let listItemCell = cell as? ListItemTableViewCell {
            let listItem = listItems[indexPath.row]
            listItemCell.listItem = listItem
            listItemCell.titleTextField.text = listItem.title
            if listItem.isCompleted {
                listItemCell.accessoryType = UITableViewCell.AccessoryType.checkmark
            } else {
                listItemCell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
            }
        }
        
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
            listItems.remove(at: indexPath.row)
            // Delete the row from the TableView
            tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         }
     }
    
    
    
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let rowToMove = listItems[fromIndexPath.row]
        listItems.remove(at: fromIndexPath.row)
        listItems.insert(rowToMove, at: to.row)
     }
    
    
    
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
 
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailSegue" {
            if let destinationVC = segue.destination as? ListItemDetailViewController {
                destinationVC.listItem = listItems[tableView.indexPathForSelectedRow!.row]
            }
        }
    }
    
}