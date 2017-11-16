//
//  FireDataWrapper.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import FirebaseDatabase

class FireDataWrapper: NSObject {
    public let data: DatabaseReference!
    
    override init() {
        Database.database().isPersistenceEnabled = true
        data = Database.database().reference()
    }
    
    public func get<T: FireDataRepresentable>(atPath path: String, withId id: String) -> T {
        guard let uuid = FireWrapper.auth.currentUser?.uid else {fatalError("No user")}
        
        return T.decode(fromChild: data.child(uuid).child(path).child(id))
    }

    public func getAllData<T: FireDataRepresentable>(atPath path: String) -> [T] {
        guard let uuid = FireWrapper.auth.currentUser?.uid else {fatalError("No user")}
        var result = [T]()
        
        data.child(uuid).child(path).observeSingleEvent(of: .value, with:
            { (snapshot) in
                for child in snapshot.children {
                    result.append(T.decode(fromChild: child as! DataSnapshot))
                }
            })
        { (error) in
            print(error.localizedDescription)
        }
        return result
    }
    
    public func set<T:FireDataRepresentable>(_ t: T, atPath path: String, withId id: String? = nil) {
        guard let uuid = FireWrapper.auth.currentUser?.uid else {fatalError("No user")}
        
        if let id = id {
            t.encode(toChild: data.child(uuid).child(path).child(id))
        } else {
            t.encode(toChild: data.child(uuid).child(path).childByAutoId())
        }
    }
}
