//
//  FireAuthWrapper.swift
//  firebase-test
//
//  Created by Илья Лошкарёв on 14.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import Firebase

import FirebaseAuthUI
import FirebaseGoogleAuthUI

protocol FireAuthWrapperDelegate: class {
    func didChangeAuth(_ auth: FireAuthWrapper, forUser user: User?)
    func failed(withError error: Error, onAction action: FireAuthWrapper.Action)
}

class FireAuthWrapper: NSObject, FUIAuthDelegate {
    
    private var didChangeAuthHandle: AuthStateDidChangeListenerHandle!
    
    public weak var delegate: FireAuthWrapperDelegate? {
        didSet {
            guard let delegate = delegate else {
                auth.removeStateDidChangeListener(didChangeAuthHandle)
                return
            }
            
            didChangeAuthHandle = auth.addStateDidChangeListener {
                (auth, user) in
                delegate.didChangeAuth(self, forUser: user)
            }
        }
    }
    
    private let auth = Auth.auth()
    
    public let ui = FUIAuth.defaultAuthUI()!
    
    public var signInController: UIViewController {
        let authVC = ui.authViewController()
        
        authVC.navigationBar.tintColor = .red
        // remove cancel button
        authVC.navigationBar.items?[0].leftBarButtonItems = nil
        return authVC
    }
    
    public var currentUser: User? {
        return auth.currentUser
    }
    
    public override init() {
        super.init()
        ui.providers = [FUIGoogleAuth()]
    }
    
    deinit {
        if delegate != nil {
            auth.removeStateDidChangeListener(didChangeAuthHandle)
        }
    }
    
    public enum Action: String {
        case register, signIn, signOut, passwordReset
    }
    
    public func register(withEmail email: String, password: String) {
        auth.createUser(withEmail: email, password: password) {
            [weak self] (usr, error) in
            guard let error = error else {return}
            self?.delegate?.failed(withError: error, onAction: .register)
        }
    }
    
    public func signIn(withEmail email: String, password: String) {
        auth.signIn(withEmail: email, password: password) {
            [weak self] (usr, error) in
            guard let error = error else {return}
            self?.delegate?.failed(withError: error, onAction: .signIn)
            self?.ui.auth?.currentUser
        }
    }
    
    public func signOut() {
        do { try auth.signOut() }
        catch let error as NSError {
            delegate?.failed(withError: error, onAction: .signOut)
        }
    }
    
    public func passwordReset(forEmail email: String) {
        auth.sendPasswordReset(withEmail: email) {
            [weak self] (error) in
            guard let error = error else {return}
            self?.delegate?.failed(withError: error, onAction: .passwordReset)
        }
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        guard let _ = user else {
            delegate?.failed(withError: error!, onAction: .signIn)
            return
        }
        //delegate?.didChangeAuth(self, forUser: user)
    }
}
