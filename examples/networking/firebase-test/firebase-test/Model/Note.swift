//
//  Note.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit

extension DateFormatter {
    static var defaultFormatter: DateFormatter {
        let df = DateFormatter()
        df.timeZone = TimeZone.current
        df.dateFormat = "HH:mm:ss dd.MM.yyyy"
        return df
    }
}

struct Note: Codable, FireDataRepresentable {
    
    let date: Date
    let title: String
    let text: String
    
    static var  path: String {
        return "notes"
    }
    
    let fireId: String!
    
    static func decode(fromSnapshot snapshot: DataSnapshot) -> Note? {
        guard let values = snapshot.value as? [String:Any] else {return nil}
        let date = DateFormatter.defaultFormatter.date(from: values[CodingKeys.date.stringValue] as! String)
        let title = values[CodingKeys.title.stringValue] as! String
        let text = values[CodingKeys.text.stringValue] as! String
        
        return Note(date: date ?? Date(), title: title, text: text, fireId: snapshot.key)
    }
    
    func encode(toChild child: DatabaseReference) {
        child.setValue([CodingKeys.date.stringValue : DateFormatter.defaultFormatter.string(from: date),
                        CodingKeys.title.stringValue : title,
                        CodingKeys.text.stringValue : text])
    }
}

extension Note: UIViewRepresentable {
    func setup(view: UIReusableType) {
        if let cell = view as? UITableViewCell {
            cell.detailTextLabel?.text = DateFormatter.defaultFormatter.string(for: self.date)
            cell.textLabel?.text = self.title
        }
    }
    
    
}
