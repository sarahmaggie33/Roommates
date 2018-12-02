//
//  BillItem.swift
//  Roommates
//
//  Created by Sarah Ericson on 11/15/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class BillItem: NSObject {
    var title:String
    var payToPerson:String
    var isPaid:Bool
    var amount:Double
    var dueDate:Date?
    
//    init(title: String, payToPerson:String, amount: Double, isPaid: Bool){
//        self.title = title
//        self.payToPerson = payToPerson
//        self.amount = amount
//        self.isPaid = isPaid
//    }
    
    override init(){
        title = "New Bill"
        payToPerson = "Name"
        amount = 0.00
        isPaid = false
    }
    
    init(title:String, payToPerson:String, amount:Double, isPaid:Bool) {
        self.title = title
        self.payToPerson = payToPerson
        self.amount = amount
        self.isPaid = isPaid
    }
}
