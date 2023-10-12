//
//  Feed.swift
//  SnapchatClone
//
//  Created by Айбек on 04.10.2023.
//

import UIKit
import Firebase

class FeedVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let fire = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getUserInfo()
        
    }

    func getUserInfo() {
        fire.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snap, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "error")
            } else {
                if snap?.isEmpty == false && snap != nil {
                    for doc in snap!.documents {
                        if let username = doc.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
