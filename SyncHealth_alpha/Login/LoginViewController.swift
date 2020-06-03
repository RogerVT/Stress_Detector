//
//  LoginViewController.swift
//  SyncHealth_alpha
//
//  Created by Roger Eduardo Vazquez Tuz on 6/1/20.
//  Copyright © 2020 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pwd: UITextField!
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        let settings = FirestoreSettings()
              Firestore.firestore().settings = settings
              db = Firestore.firestore()
    
    }
    
    
    @IBAction func logIn(_ sender: Any) {
        if let mail = email.text, let pwd = pwd.text, !mail.isEmpty && !pwd.isEmpty  {
            Auth.auth().signIn(withEmail: mail, password: pwd) { (user, error) in
                       if error == nil {
                        self.retrieveUserData(uMail: mail)
                        try! AppDelegate.keychain?.set(mail, key: "mail")
                        UIApplication.setRootView(HomeViewController.instantiate(from: .Home))
                       } else {
                              let alertController = UIAlertController(title: "Error", message: "Algo salió mal!", preferredStyle: .alert)
                                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                       
                                         alertController.addAction(defaultAction)
                                         self.present(alertController, animated: true, completion: nil)
                       }
                   }
        } else {
            let alertController = UIAlertController(title: "Error", message: "Campos faltantes!", preferredStyle: .alert)
                      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                     
                       alertController.addAction(defaultAction)
                       self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func retrieveUserData(uMail: String) {
        db.collection("userGeneral").whereField("email", isEqualTo: uMail).getDocuments() { (querySnapshot,err) in
                   if let err = err {
                       print("Error: \(err)")
                   } else {
                       for document in querySnapshot!.documents {
                        self.storeUserData(nombre: document.data()["nombre"] as? String ?? "", apellido: document.data()["apellido"] as? String ?? "", roomID: document.data()["roomID"] as? String ?? "" , departamento: document.data()["departamento"] as? String ?? "", nomina: document.documentID)
                       }
                   }
               }
    }
    
    private func storeUserData(nombre: String, apellido: String, roomID: String, departamento: String, nomina: String) {
        try! AppDelegate.keychain?.set(nombre + " " + apellido, key: "nombre")
        try! AppDelegate.keychain?.set(roomID, key: "roomID")
        try! AppDelegate.keychain?.set(departamento, key: "departamento")
        try! AppDelegate.keychain?.set(nomina, key: "nomina")
    }
    
}
