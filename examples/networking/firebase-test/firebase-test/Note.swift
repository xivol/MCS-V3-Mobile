//
//  Note.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Note: Codable, FireDataRepresentable {
    let date: Date
    let title: String
    let text: String
    
    static var storage: [Note] = {
        if let user = FireWrapper.auth.currentUser {
            return FireWrapper.data.getAllData(atPath: Note.path)
        } else {
            return [Note]()
        }
    }()
    
    static var  path: String {
        return "notes"
    }
    
    static func decode(fromChild child: DatabaseReference) -> Note {
        let date = child.value(forKey: CodingKeys.date.stringValue) as! Date
        let title = child.value(forKey: CodingKeys.title.stringValue) as! String
        let text = child.value(forKey: CodingKeys.text.stringValue) as! String
        
        return Note(date: date, title: title, text: text)
    }
    
    static func decode(fromChild child: DataSnapshot) -> Note {
        let date = child.value(forKey: CodingKeys.date.stringValue) as! Date
        let title = child.value(forKey: CodingKeys.title.stringValue) as! String
        let text = child.value(forKey: CodingKeys.text.stringValue) as! String
        
        return Note(date: date, title: title, text: text)
    }
    
    func encode(toChild child: DatabaseReference) {
        child.setValue(date, forKey: CodingKeys.date.stringValue)
        child.setValue(title, forKey: CodingKeys.title.stringValue)
        child.setValue(text, forKey: CodingKeys.text.stringValue)
    }
}
