//
//  AppDelegate.swift
//  SyncHealth_alpha
//
//  Created by Roger Eduardo Vazquez Tuz on 5/23/20.
//  Copyright © 2020 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import Firebase
import KeychainAccess

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var keychain: Keychain?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        AppDelegate.keychain = Keychain(server: Bundle.main.bundleIdentifier!, protocolType: .https)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = #colorLiteral(red: 0.9960784314, green: 0.9960784314, blue: 0.9960784314, alpha: 1)
        
        if Auth.auth().currentUser != nil {
            let homeViewController = HomeViewController.instantiate(from: .Home)
            self.window?.rootViewController = homeViewController
        } else {
            let loginViewController = LoginViewController.instantiate(from: .Login)
            self.window?.rootViewController = loginViewController
        }
        
        self.window?.makeKeyAndVisible()
        return true
    }



}

