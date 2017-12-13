//
//  UIViewRepresentable.swift
//  skittles
//
//  Created by Илья Лошкарёв on 07.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

public protocol UIReusableType: class {
    static var reuseIdentifier: String { get }
}

extension UIReusableType {
    public static var reuseIdentifier: String {
        return "\(Self.self).reuseId"
    }
}

extension UITableViewCell: UIReusableType {}
extension UICollectionReusableView : UIReusableType {}

public protocol UIViewRepresentable {
    func setup(view: UIReusableType)
}

public protocol DataSource: class {
    associatedtype DataType: UIViewRepresentable
    
    var numberOfSections: Int { get }
    func numberOfItems(inSection section: Int) -> Int
    subscript(indexPath:IndexPath) -> DataType { get }
}

public protocol UIViewControllerRepresentable {
    associatedtype Controller
    var vc: Controller { get }
}
