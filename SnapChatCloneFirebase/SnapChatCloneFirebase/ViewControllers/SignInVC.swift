//
//  ViewController.swift
//  SnapChatCloneFirebase
//
//  Created by Onur Sir on 30.12.2022.
//

import UIKit
import Firebase
class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButton(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" && emailText.text != "" {
            
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (auth, error) in
                 
                if error != nil {
                    self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    let firestore = Firestore.firestore()
                    
                    let userDictioanary = ["email": self.emailText.text!, "username": self.usernameText.text!] as [String : Any]
                    
                    firestore.collection("UserInfo").addDocument(data: userDictioanary) { error in
                    
                        if error != nil {
                            
                        }
                        
                    }
                    
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        }else {
            self.makeAlert(Title: "error", message: "Ups Errorrs")
        }
    }
    
    func makeAlert(Title:String, message: String) {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okeybutton = UIAlertAction(title: "okey", style: UIAlertAction.Style.default)
        alert.addAction(okeybutton)
        present(alert, animated: true)
        
    }
    @IBAction func signinButton(_ sender: Any) {
        
        if passwordText.text != "" && emailText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { result,error  in
                
                if error != nil {
                    self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
            }
            }
            
        } else {
            self.makeAlert(Title: "Error", message: "password&email is wrong")
        }
        
        
    }
}

