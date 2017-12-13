//
//  EditViewController.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 15.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var textInput: UITextView!
    
    @IBAction func doneTouched(_ sender: UIBarButtonItem) {
        
        let note = Note(date: Date(), title: titleInput.text!, text: textInput.text, fireId: nil)
        FireWrapper.data.setUserData(value: note, atPath: Note.path)
        
        if let vc = navigationController?.popViewController(animated: true) {
            vc.dismiss(animated: false)
        } else {
            self.dismiss(animated: true)
        }
    }
}
