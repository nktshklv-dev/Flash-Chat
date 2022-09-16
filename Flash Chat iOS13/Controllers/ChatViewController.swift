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

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "Hey"),
        Message(sender: "nikita@com", body: "Hello!"),
        Message(sender: "1@2.com", body: "what's up?")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        

    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
     
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

extension ChatViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].body
        return cell
        
        
        
    }
    
    
}



 


