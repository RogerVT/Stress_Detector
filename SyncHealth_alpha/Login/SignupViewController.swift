//
//  SignupViewController.swift
//  SyncHealth_alpha
//
//  Created by Roger Eduardo Vazquez Tuz on 6/1/20.
//  Copyright © 2020 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var apellido: UITextField!
    @IBOutlet weak var nomina: UITextField!
    @IBOutlet weak var codigo: UITextField!
    @IBOutlet weak var correo: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var pwdcopy: UITextField!
    
    var pertainsRoom = false
    var dep = ""
    var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissKey()
        pwdcopy.delegate = self
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        
    }
    
    @IBAction func alogin(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        if nonEmpty() || comparePwd() {
            if pertainsRoom {
                Auth.auth().createUser(withEmail: correo.text!, password: pwd.text!) { (user, error) in
                    if error == nil {
                        FBMethods().documentUser(nomina: self.nomina.text!, room: self.codigo.text!, correo: self.correo.text!, nombre: self.nombre.text!, apellido: self.apellido.text!, dep: self.dep)
                        self.storeCredentials(rid: self.codigo.text!, depart: self.dep, nom: self.nombre.text! + " " + self.apellido.text!, nomin: self.nomina.text!, email: self.correo.text!)
                        UIApplication.setRootView(HomeViewController.instantiate(from: .Home))
                    }
                
                }
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: "El cuarto a registrar no existe o el usuario no pertenece a el", preferredStyle: .alert)
                                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                   
                                     alertController.addAction(defaultAction)
                                     self.present(alertController, animated: true, completion: nil)
                
            }
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Campos faltantes y/o contraseña no son iguales!", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                               
                                 alertController.addAction(defaultAction)
                                 self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    private func nonEmpty() -> Bool {
        if let nomina = nomina.text, let code = codigo.text, let mail = correo.text, let pwd = pwd.text, let pwdc = pwdcopy.text, let nombre = nombre.text, let apellido = apellido.text, !nomina.isEmpty && !code.isEmpty, !mail.isEmpty, !pwd.isEmpty, !pwdc.isEmpty, !nombre.isEmpty, !apellido.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    private func comparePwd() -> Bool {
        if let pwd = pwd.text, let pwdc = pwdcopy.text, pwd == pwdc {
            return true
        } else {
            return false
        }
    }
    
    private func roomExists()  {
        let query = db.collection("rooms").whereField("roomID", isEqualTo: codigo.text!).whereField("miembros", arrayContains: nomina.text!)
        
        query.getDocuments() { (querySnapshot,err) in
            if let err = err {
                self.pertainsRoom = false
                print("Error: \(err)")
            } else {
                self.pertainsRoom = true
                for document in querySnapshot!.documents {
                    let data = document.data()
                    self.dep = data["departamento"] as? String ?? "not_loaded"
                    
                }
            }
        
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        roomExists()
    }
    
    private func storeCredentials(rid: String, depart: String, nom: String, nomin: String, email: String) {
        try! AppDelegate.keychain?.set(rid, key: "roomID")
        try! AppDelegate.keychain?.set(depart, key: "departamento")
        try! AppDelegate.keychain?.set(nomin, key: "nomina")
        try! AppDelegate.keychain?.set(nom, key: "nombre")
        try! AppDelegate.keychain?.set(email, key: "mail")
    }
}
