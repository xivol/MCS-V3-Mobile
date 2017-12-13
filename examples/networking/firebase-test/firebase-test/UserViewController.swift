//
//  UserViewController.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 21.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI

class UserViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var user: User?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        user = FireWrapper.auth.currentUser
        titleLabel.text = user?.displayName
        emailLabel.text = user?.email
        imageView.sd_setImage(with: user?.photoURL)
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
