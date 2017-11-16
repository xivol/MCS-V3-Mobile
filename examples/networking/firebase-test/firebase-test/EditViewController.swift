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
        let note = Note(date: Date(), title: titleInput.text!, text: textInput.text)
        FireWrapper.data.set(note, atPath: Note.path)
        
        self.navigationController?.popViewController(animated: true)?.dismiss(animated: false, completion: nil)
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
