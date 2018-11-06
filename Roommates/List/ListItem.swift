//
//  ListItem.swift
//  Roommates
//
//  Created by Sarah Ericson on 10/30/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import UIKit

class ListItem: NSObject {
    var title:String
    var notes:String?
    var isCompleted:Bool
    var date:Date?
    
    override init(){
        title = "New List Item"
        isCompleted = false
    }
}

