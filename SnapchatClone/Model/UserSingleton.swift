//
//  UserSingleton.swift
//  SnapchatClone
//
//  Created by Айбек on 13.10.2023.
//

import Foundation

class UserSingleton {
    
    static var sharedUserInfo = UserSingleton()
    var email = ""
    var username = ""
    
    private init() {
        
    }
}
