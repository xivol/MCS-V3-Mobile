//
//  FirebaseDataDelegate.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 17.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import FirebaseDatabase

typealias FirebaseDataObservers = [DataEventType : (DataSnapshot)->Void]

@objc protocol FirebaseDataDelegate {
    var fireSourceRef: DatabaseReference! {get set}
    var fireObservers: NSMutableDictionary {get set}
    @objc optional func fireValue(withSnapshot snapshot: DataSnapshot)
    @objc optional func fireChildAdded(withSnapshot snapshot: DataSnapshot)
    @objc optional func fireChildRemoved(withSnapshot snapshot: DataSnapshot)
    @objc optional func fireChildMoved(withSnapshot snapshot: DataSnapshot)
    @objc optional func fireChildChanged(withSnapshot snapshot: DataSnapshot)
}

extension DatabaseReference {
    func connect(delegate: FirebaseDataDelegate) {
        if let source = delegate.fireSourceRef {
            if source.key != self.key {
                source.disconnect(delegate: delegate)
            }
        }
        
        delegate.fireSourceRef = self
        if let observer = delegate.fireValue(withSnapshot:){
            delegate.fireObservers.setObject(self.observe(.value, with: observer), forKey: DataEventType.value.rawValue as NSCopying)
        }
        if let observer = delegate.fireChildAdded(withSnapshot:) {
            delegate.fireObservers.setObject(self.observe(.childAdded, with: observer), forKey: DataEventType.childAdded.rawValue as NSCopying)
        }
        if let observer = delegate.fireChildRemoved(withSnapshot:) {
            delegate.fireObservers.setObject(self.observe(.childRemoved, with: observer), forKey: DataEventType.childRemoved.rawValue as NSCopying)
        }
        if let observer = delegate.fireChildMoved(withSnapshot:) {
            delegate.fireObservers.setObject(self.observe(.childMoved, with: observer), forKey: DataEventType.childMoved.rawValue as NSCopying)
        }
        if let observer = delegate.fireChildChanged(withSnapshot:) {
            delegate.fireObservers.setObject(self.observe(.childChanged, with: observer), forKey: DataEventType.childChanged.rawValue as NSCopying)
        }
    }
    
    func disconnect(delegate: FirebaseDataDelegate) {
        for (_, handle) in delegate.fireObservers {
            self.removeObserver(withHandle: handle as! UInt)
        }
    }
    
    func load(with completion: @escaping (DataSnapshot)->Void) {
        self.observeSingleEvent(of: .value, with: completion)
    }
}

