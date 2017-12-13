//
//  FireDataRepresentable.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol FireDataRepresentable {
    static var path: String {get}
    
    var fireId: String! {get}
    func encode(toChild child: DatabaseReference)
    static func decode(fromSnapshot snapshot: DataSnapshot) -> Self?
}
