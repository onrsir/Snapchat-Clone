//
//  FeedVC.swift
//  SnapChatCloneFirebase
//
//  Created by Onur Sir on 30.12.2022.
//

import UIKit
import Firebase
import SDWebImage
class FeedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    

    @IBOutlet weak var tableView: UITableView!
    let fireStoreDataBase = Firestore.firestore()
    var snapArray = [Snap]()
    var ChoosenSnap : Snap?
     
    var defaultUsername : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        getsSnapsFromFirebase()
        
        getUnserInfo()

    }
    
    func getsSnapsFromFirebase(){
        
        fireStoreDataBase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.makeAlert(Title: "Error", message: error?.localizedDescription ?? "errorr")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        if let username = document.get("snapOwner") as? String {
                            
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    
                                    if let saatFarki = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour{
                                        
                                        if saatFarki >= 24 {
                                            // snap 24 saati geçtiyse snaplar silinecek
                                            self.fireStoreDataBase.collection("Snaps").document(documentId).delete()
                                        }else {
                                             let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifferent: 24 - saatFarki)
                                            
                                            self.snapArray.append(snap)
                                        }
                                      
                                        
                                    }
           
                                }
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()

        }
    }
    
 
    func getUnserInfo () {
        fireStoreDataBase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (snapshot, error) in
            if error != nil {
                self.makeAlert(Title: "error", message: error?.localizedDescription ?? "error")
                
            }else {
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        
                        if let username = document.get("username") as? String {
                            
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! FeedCell
        
        let image = UIImage(named: "images1")
        cell.configure(with: image!)
        
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        cell.feedimageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapVC
            
            destinationVC.selectedSnap = ChoosenSnap
        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ChoosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
}
