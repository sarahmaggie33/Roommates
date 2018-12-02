//
//  Constants.swift
//  Roommates
//
//  Created by Sarah Ericson on 12/1/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import Firebase

struct Constants  {
    struct NotificationKeys {
        static let SignedIn = "onSignInCompleted"
    }
    
    struct Segues {
        static let SignIn = "SignIn"
        static let FpToSignIn = "FPToSignIn"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let photoURL = "photoUrl"
        static let imageURL = "imageUrl"
    }
}
