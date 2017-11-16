//
//  ShowViewController.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    var note: Note?
    
    override func viewWillAppear(_ animated: Bool) {
        guard let note = self.note else {return}
        dateLabel.text = note.date.description
        titleLabel.text = note.title
        textView.text = note.text
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
