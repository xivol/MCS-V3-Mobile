//
//  FireDataWrapper.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import FirebaseDatabase

class FireDataWrapper: NSObject {
    public let ref: DatabaseReference!
    
    override init() {
        Database.database().isPersistenceEnabled = true
        ref = Database.database().reference()
    }
    
    public var userData: DatabaseReference {
        guard let uuid = FireWrapper.auth.currentUser?.uid else { fatalError("No User") }
        return ref.child(uuid)
    }
    
    public func setUserData<T:FireDataRepresentable>(value: T, atPath path: String, withId id: String? = nil) {
        if let id = id {
            value.encode(toChild: userData.child(path).child(id))
        } else {
            value.encode(toChild: userData.child(path).childByAutoId())
        }
    }
}
