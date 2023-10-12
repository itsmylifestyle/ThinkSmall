//
//  Upload.swift
//  SnapchatClone
//
//  Created by Айбек on 04.10.2023.
//

import UIKit
import Firebase

class UploadVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gest = UITapGestureRecognizer(target: self, action: #selector(choosePic))
        imageView.addGestureRecognizer(gest)
    }
    

    @objc func choosePic() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            let firestore = Firestore.firestore()
                            
                            
                            firestore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snap, error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    if snap?.isEmpty == false && snap != nil {
                                        for doc in snap!.documents {
                                            let docId = doc.documentID
                                            if var imgUrlArray = doc.get("imgUrlArray") as? [String] {
                                                imgUrlArray.append(imageUrl!)
                                                
                                                let additionalDict = ["imgUrlArray" : imgUrlArray] as [String : Any]
                                                
                                                firestore.collection("Snaps").document(docId).setData(additionalDict, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0
                                                        self.imageView.image = UIImage(named: "folder.badge.plus")
                                                    }
                                                }
                                            }
                                        }
                                    } else {
                                        let snapDictionary = ["imgUrlArray" : [imageUrl!], "snapOwner" : UserSingleton.sharedUserInfo.username, "date" : FieldValue.serverTimestamp()] as [String : Any]
                                        firestore.collection("Snaps").addDocument(data: snapDictionary) { error in
                                            if error != nil {
                                                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                                self.imageView.image = UIImage(named: "folder.badge.plus")
                                            }
                                        }
                                    }//there is error in firebase when I save more than 1 image
                                }    //fix it tomorrow
                            }
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
