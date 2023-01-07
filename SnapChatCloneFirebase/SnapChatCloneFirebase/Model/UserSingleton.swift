//
//  UserSingleton.swift
//  SnapChatCloneFirebase
//
//  Created by Onur Sir on 1.01.2023.
//

import Foundation

class UserSingleton {
 
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    
    private init(){
        
    }
}
