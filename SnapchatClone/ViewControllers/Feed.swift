//
//  Feed.swift
//  SnapchatClone
//
//  Created by Айбек on 04.10.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    let fire = Firestore.firestore()
    
    var snapArray = [snapCellStruct]()
    
    var chosenSnap : snapCellStruct?
    var timeLeft : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFirestore()
        getUserInfo()
    }
    
    func getSnapsFromFirestore() {
        fire.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snap, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if snap?.isEmpty == false && snap != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for doc in snap!.documents {
                        
                        let docuID = doc.documentID
                        
                        if let username = doc.get("snapOwner") as? String {
                            if let imageUrlArr = doc.get("imgUrlArray") as? [String] {
                                if let date = doc.get("date") as? Timestamp {
                                    
                                    if let differnce = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if differnce >= 24 {
                                            self.fire.collection("Snaps").document(docuID).delete { error in
                                                
                                            }
                                        }
                                        
                                        //TIMELEFT -> SNAPVC
                                        self.timeLeft = 24 - differnce
                                    }
                                    let snapObject = snapCellStruct(username: username, imgUrlArr: imageUrlArr, date: date.dateValue())
                                    self.snapArray.append(snapObject)
                                }
                            }
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
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

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cellgg", for: indexPath) as! FeedCell
        cell.usernameCell.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imgUrlArr[0]))
        cell.feedImageView.contentMode = UIView.ContentMode.scaleAspectFit
        print("Image URL for cell at indexPath \(indexPath): \(snapArray[indexPath.row].imgUrlArr[0])")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            destinationVC.selectedTime = self.timeLeft
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
