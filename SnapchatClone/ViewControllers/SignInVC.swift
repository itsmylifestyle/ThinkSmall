//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Айбек on 04.10.2023.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func SignInAction(_ sender: Any) {
        if usernameInput.text! != "" && passwordInput.text! != "" && emailInput.text! != "" {
            Auth.auth().signIn(withEmail: self.emailInput.text!, password: self.passwordInput.text!) { res, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    self.performSegue(withIdentifier: "FeedVCsegue", sender: nil)
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username or password is missing")
        }
    }
    
    
    @IBAction func SignUpAction(_ sender: Any) {
        if usernameInput.text! != "" && passwordInput.text! != "" && emailInput.text! != "" {
            Auth.auth().createUser(withEmail: emailInput.text!, password: passwordInput.text!) { auth, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    let firestoreMy = Firestore.firestore()
                    let userDict = ["email" : self.emailInput.text!, "username" : self.usernameInput.text!] as [String : Any]
                    firestoreMy.collection("UserInfo").addDocument(data: userDict) { error in
                        if error != nil {
                            self.makeAlert(title: "Error", message: "Connection may be lost")
                        }
                    }
                    self.performSegue(withIdentifier: "FeedVCsegue", sender: nil)
                }
            }
        } else {
            self.makeAlert(title: "Error", message: "Username or password is missing")
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

