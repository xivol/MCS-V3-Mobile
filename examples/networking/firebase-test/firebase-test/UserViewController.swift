//
//  UserViewController.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 21.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = FireWrapper.auth.currentUser
        titleLabel.text = user?.displayName
        emailLabel.text = user?.email
    }
    
    @IBAction func signOutTouched(_ sender: UIButton) {
        FireWrapper.auth.signOut()
    }
    
    @IBAction func resetPassword(_ sender: UIButton) {
        if let email = user?.email {
            FireWrapper.auth.passwordReset(forEmail: email)
        }
    }
}
