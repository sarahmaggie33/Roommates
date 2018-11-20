//
//  BillsAddEditPlayerDelegate.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import Foundation

protocol BillsAddEditDelegate {
    func cancelAddEditBill()
    func saveAddEditBill(_ bill:BillItem)
}
