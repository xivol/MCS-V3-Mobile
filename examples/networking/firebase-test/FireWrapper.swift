//
//  FireWrapper.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 13.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Firebase
import FirebaseDatabase

class FireWrapper {
    public static let shared = FireWrapper()
    
    public let auth: FireAuthWrapper!
    public static var auth: FireAuthWrapper {
        return shared.auth
    }
    
    public let data: FireDataWrapper!
    public static var data: FireDataWrapper {
        return shared.data
    }
    
    private init(){
        FirebaseApp.configure()
        auth = FireAuthWrapper()
        data = FireDataWrapper()
    }
    
    public enum _Error: Error {
        case unknown
    }
}
