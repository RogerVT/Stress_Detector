//
//  HomeViewController.swift
//  SyncHealth_alpha
//
//  Created by Roger Eduardo Vazquez Tuz on 6/1/20.
//  Copyright © 2020 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var nomina: UILabel!
    @IBOutlet weak var departamento: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
        
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        do {
                     try Auth.auth().signOut()
                 } catch let signOutError as NSError {
                   print ("Error signing out: %@", signOutError)
                 }
                 
                 try! AppDelegate.keychain?.remove("mail")
        try! AppDelegate.keychain?.remove("roomID")
        try! AppDelegate.keychain?.remove("nombre")
        try! AppDelegate.keychain?.remove("departamento")
        try! AppDelegate.keychain?.remove("nomina")

        UIApplication.setRootView(LoginViewController.instantiate(from: .Login), options: UIApplication.logoutAnimation)
    }
    
    private func setLabel() {

        room.text = AppDelegate.keychain!["roomID"]
        name.text = AppDelegate.keychain!["nombre"]
        nomina.text = AppDelegate.keychain!["nomina"]
        departamento.text = AppDelegate.keychain!["departamento"]
    }
    
    

}
