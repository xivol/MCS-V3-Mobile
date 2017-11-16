//
//  Note4Codable.swift
//  notes-archive
//
//  Created by Илья Лошкарёв on 01.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Foundation
import UIKit

struct Note4Codable: Codable, CustomStringConvertible {
    let content: String
    let date: Date
    let color: UIColor
    
//    enum CodingKeys: String, CodingKey {
//        case color, date, content
//    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        date = try container.decode(Date.self, forKey: .date)
//        content =  try container.decode(String.self, forKey: .content)
//
//        color = try container.decode(UIColor.self, forKey: .color)
//    }
    
//    func encode(to encoder: Encoder) throws {
//         var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(date, forKey: .date)
//        try container.encode(content, forKey: .content)
//
//        //let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
//        try container.encode(color, forKey: .color)
//    }

    static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ss dd.MM.yyyy"
        return df
    }()

    var description: String {
        return "(\(Note4Codable.dateFormatter.string(from: date))) " + content
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encode(_ value: NSCoding, forKey key: Self.Key) throws {
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        try self.encode(data, forKey: key)
    }
}

extension KeyedDecodingContainerProtocol {
    func decode<T>(_ type: T.Type, forKey key: Self.Key)  throws -> T where T : NSCoding {
        let data = try self.decode(Data.self, forKey: key)
        return NSKeyedUnarchiver.unarchiveObject(with: data) as! T
    }
}
