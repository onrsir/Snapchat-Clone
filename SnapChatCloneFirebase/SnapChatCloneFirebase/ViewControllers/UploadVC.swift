//
//  UploadVC.swift
//  SnapChatCloneFirebase
//
//  Created by Onur Sir on 30.12.2022.
//

import UIKit
import FirebaseStorage
import Firebase
class UploadVC: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // görselin tıklanabilirliğini aktif etme
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChoosePicture))
        
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    // fotoğraf seçme
    @objc func ChoosePicture() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    // seçtikten sonra
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }

    @IBAction func uploadButton(_ sender: Any) {
        
        // imageyi dataya kaydetme
        
        
        // STORAGE
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let medilaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality:0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = medilaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data, metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(Title: "error", message: error?.localizedDescription ?? "ERROR")
                } else {
                    
                    imageRef.downloadURL { (url, error) in
                        if error == nil {
                            
                            let imageUrl = url?.absoluteString
                            
                            // FİRESTORE
                            let fireStore = Firestore.firestore()
                            
                            // DAHA ÖNCE STORY ATMIŞ MI URL İLE KONTROL EDİCEZ
                            
                            fireStore.collection("Snaps").whereField("snapOwner", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { (snapshot, error) in
                                if error != nil {
                                    self.makeAlert(Title: "error", message: error?.localizedDescription ?? "errors")
                                } else {
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents {
                                            

                                          
                                            let documentId = document.documentID
                                            
                                            if var imageUrlArray = document.get("imageUrlArray") as? [String] {
                                                
                                                imageUrlArray.append(imageUrl!)
                                                
                                                let additaionalDictioany = ["imageUrlArray" : imageUrlArray] as [String : Any]
                                                
                                                fireStore.collection("Snaps").document(documentId).setData(additaionalDictioany, merge: true) { error in
                                                    if error == nil {
                                                        self.tabBarController?.selectedIndex = 0

                                                    }
                                                }
                                            }
                                            
                                        }
                                    } else {
                                        let snapDictionary = ["imageUrlArray" : [imageUrl!], "snapOwner" :UserSingleton.sharedUserInfo.username,"date" : FieldValue.serverTimestamp()] as [String : Any]
                                        
                                        fireStore.collection("Snaps").addDocument(data : snapDictionary) { error in
                                            if error != nil {
                                                self.makeAlert(Title: "error", message: error?.localizedDescription ?? "error")
                                                
                                            } else {
                                                self.tabBarController?.selectedIndex = 0
                                            
                                            }
                                        }
                                    }
                                }
                            }
                            
                          
                        }
                        
                    }
                    
                }
            }
        }
    }
    func makeAlert(Title:String, message: String) {
        let alert = UIAlertController(title: Title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okeybutton = UIAlertAction(title: "okey", style: UIAlertAction.Style.default)
        alert.addAction(okeybutton)
        present(alert, animated: true)
        
    }


    }
