//
//  NotesViewController.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
import FirebaseDatabase
@objc class NotesViewController: UITableViewController, FirebaseDataDelegate {

    var storage: [Note]?
    var fireSourceRef: DatabaseReference!
    var fireObservers = NSMutableDictionary()
    
    override func viewDidLoad() {
        fireSourceRef = FireWrapper.data.userData.child(Note.path)
        navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        storage = [Note]()
        refreshControl?.beginRefreshing()
        fireSourceRef.load(with: self.loadData(withSnapshot:))
        fireSourceRef.connect(delegate: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fireSourceRef.disconnect(delegate: self)
    }
    
    @IBAction func userDidRefresh(_ sender: UIRefreshControl) {
        print("refreshing")
        fireSourceRef.load(with: self.loadData(withSnapshot:))
    }
    
    func loadData(withSnapshot snapshot: DataSnapshot) {
        print("loaded")

        var r = [Note]()
        
        for child in snapshot.children {
            if let note = Note.decode(fromSnapshot: child as! DataSnapshot) {
                r.append(note)
            }
        }
        storage = r
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    // MARK: - Firebase data delegate
    
    func fireChildRemoved(withSnapshot snapshot: DataSnapshot) {
        print("removed")
        var removedIds = [IndexPath]()
        
        if let index = storage?.index(where: { $0.fireId == snapshot.key}) {
            removedIds.append(IndexPath(row: index, section: 0))
            storage?.remove(at: index)
        }
        tableView.deleteRows(at: removedIds, with: .automatic)
    }
    
    func fireChildAdded(withSnapshot snapshot: DataSnapshot) {
        guard storage?.index(where: {$0.fireId == snapshot.key}) == nil
            else { return }
        print("added")
        
        if let note = Note.decode(fromSnapshot: snapshot) {
            storage?.append(note)
            tableView.insertRows(at: [IndexPath(row: storage!.count-1, section:0)], with: .automatic)
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(storage?.count ?? 0)
        return storage?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        let note = storage?[indexPath.row]
        
        note?.setup(view: cell)

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let id = storage?[indexPath.row].fireId {
                fireSourceRef.child(id).removeValue()
            }
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case is ShowViewController:
            let dst = segue.destination as! ShowViewController
            if let index = tableView.indexPathForSelectedRow?.row {
                dst.note = storage?[index]
            }
        default:
            break
        }
    }
    

}
