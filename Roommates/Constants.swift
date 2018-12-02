//
//  Constants.swift
//  Roommates
//
//  Created by Sarah Ericson on 12/1/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import Firebase

struct Constants  {
    struct refs {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
    }
}
