//
//  AppDelegate.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 21.09.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
import FirebaseAuth


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    var storyboard: UIStoryboard?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)        
        
        FireWrapper.auth.delegate = self
        window?.rootViewController = FireWrapper.auth.signInController
        window?.makeKeyAndVisible()
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?
        if FireWrapper.auth.ui.handleOpen(url, sourceApplication: sourceApplication) {
            return true
        }
        
        return false
    }
}

extension AppDelegate: FireAuthWrapperDelegate {
    
    func didChangeAuth(_ auth: FireAuthWrapper, forUser user: User?) {
        if let user = user {
            print("signed in as", user.displayName!)
            window?.rootViewController = storyboard?.instantiateInitialViewController()
        } else {
            print("signed out")
            window?.rootViewController = FireWrapper.auth.signInController
        }
    }
    
    func failed(withError error: Error, onAction action: FireAuthWrapper.Action) {
        let nerror = error as NSError
        print("Error", nerror.localizedDescription)
        
        let alert = UIAlertController(title: "Error", message: nerror.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

