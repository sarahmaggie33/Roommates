//
//  BillsTableViewDelegate.swift
//  Roommates
//
//  Created by Sarah Ericson on 12/1/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import Foundation

protocol ClassBTVDelegate: class {
    func saveToTableView(_ bill:BillItem)
}
