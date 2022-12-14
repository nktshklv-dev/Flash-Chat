//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        messageTextfield.delegate = self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        
        loadMessages()
        

    }
    
    func loadMessages(){
     
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { querySnapshot, error in
            self.messages = []
            guard error == nil else {
                print("There was a issue retrieiving data from Firestore \(error!.localizedDescription)")
                return
                
            }
            
            guard let snapshotDocuments = querySnapshot?.documents else {return}
            for doc in snapshotDocuments{
                
                let data = doc.data()
                guard let sender = data[K.FStore.senderField] as? String else {return}
                guard let body = data[K.FStore.bodyField] as? String else {return}
                
                let newMessage = Message(sender: sender, body: body)
                self.messages.append(newMessage)
                        
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
                       
            }
                
            
    }
}
    
    @IBAction func sendPressed(_ sender: UIButton) {
      
        guard messageTextfield.text != "" else {
            let ac = UIAlertController(title: "You can't send an empty message!", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        guard let messageBody = messageTextfield.text else {return}
        guard let messageSender = Auth.auth().currentUser?.email else {return}
      
        
        
        db.collection(K.FStore.collectionName).addDocument(
            data: [K.FStore.senderField: messageSender,
                   K.FStore.bodyField: messageBody,
                   K.FStore.dateField: Date().timeIntervalSince1970]){
         error in
            if let e = error{
                print(e.localizedDescription)
            }
            else {
                print("Successfully saved data. ")
                DispatchQueue.main.async {
                    self.messageTextfield.text = ""
                }
               
            }
        }
        
        
        
    }
    
    @IBAction func LogoutPressed(_ sender: UIBarButtonItem) {
        
    let firebaseAuth = Auth.auth()
        
     do {
        try firebaseAuth.signOut()
        navigationController?.popToRootViewController(animated: true)
      } catch let signOutError as NSError {
        print("Error signing out: %@", signOutError)
       }
      
    }
    
}


//MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let message = messages[indexPath.row]
       
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        if message.sender == Auth.auth().currentUser?.email{
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.messageTextLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageTextLabel.textColor = UIColor(named: K.BrandColors.purple)
        }
        cell.messageTextLabel.text = message.body
        return cell
        
        
        
    }
    
    
}


//MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.endEditing(true)
    }
}



 


