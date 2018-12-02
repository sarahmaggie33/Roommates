//
//  MeasurementHelper.swift
//  Roommates
//
//  Created by Sarah Ericson on 12/2/18.
//  Copyright © 2018 Sarah Ericson. All rights reserved.
//

import Firebase

class MeasurementHelper: NSObject {
    
    static func sendLoginEvent() {
        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
    }
    
    static func sendLogoutEvent() {
        Analytics.logEvent("logout", parameters: nil)
    }
    
    static func sendMessageEvent() {
        Analytics.logEvent("message", parameters: nil)
    }
}
