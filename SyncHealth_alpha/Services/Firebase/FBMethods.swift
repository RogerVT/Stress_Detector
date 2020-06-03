//
//  FBMethods.swift
//  SyncHealth_alpha
//
//  Created by Roger Eduardo Vazquez Tuz on 6/1/20.
//  Copyright © 2020 Roger Eduardo Vazquez Tuz. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class FBMethods {

    var db:Firestore!
    
    init() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    func documentUser(nomina: String, room: String, correo: String, nombre: String, apellido: String, dep: String) -> Void {
        db.collection("userGeneral").document(nomina).setData([
            "nombre": nombre,
            "apellido": apellido,
            "roomID":room,
            "email":correo,
            "departamento":dep
            ]) { err in
                if let err = err {
                       print("Error writing document: \(err)")
                   } else {
                       print("Document successfully written!")
                   }
                
        }
    }
    
    func retrieveUserData(uMail: String) {
        
        let query = db.collection("userGeneral").whereField("email", isEqualTo: uMail)
        
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document! \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print(data)
                   /* let codigo = data["roomID"] as? String ?? "fake"
                    try! AppDelegate.keychain?.set(codigo, key: "roomID")
                    let name = data["nombre"] as? String ?? "john"
                    let lastname = data["apellido"] as? String ?? "doe"
                    let completo = name + lastname
                    try! AppDelegate.keychain?.set(completo, key: "nombre")
                    let depnom = data["departamento"] as? String ?? "fake"
                    try! AppDelegate.keychain?.set(depnom, key: "departamento")
                    let nomina = document.documentID
                    try! AppDelegate.keychain?.set(nomina, key: "nomina")*/
                }
            }
        
        }
        }
    
    
    

    
    
    
}
