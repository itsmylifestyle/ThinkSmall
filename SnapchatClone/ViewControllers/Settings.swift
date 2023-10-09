//
//  Settings.swift
//  SnapchatClone
//
//  Created by Айбек on 04.10.2023.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toSignVC", sender: nil)
        } catch {
            
        }
    }
    
    
}
