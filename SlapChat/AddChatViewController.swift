//
//  AddChatViewController.swift
//  SlapChat
//
//  Created by Flatiron School on 7/20/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class AddChatViewController: UIViewController {
    
    @IBOutlet weak var chatTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var dataStore = DataStore.sharedDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.removeConstraints(view.constraints)
        constrainTextFieldAndButtons()
    }
    
    func constrainTextFieldAndButtons() {
        chatTextField.translatesAutoresizingMaskIntoConstraints = false
        chatTextField.removeConstraints(chatTextField.constraints)
        chatTextField.widthAnchor.constraintEqualToAnchor(view.widthAnchor, multiplier: 0.75).active = true
        chatTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        chatTextField.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: -30.0).active = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.removeConstraints(cancelButton.constraints)
        cancelButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 20.0).active = true
        cancelButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: -35.0).active = true
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.removeConstraints(addButton.constraints)
        addButton.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: 20.0).active = true
        addButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor, constant: 35.0).active = true
    }
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        let messageDescription = NSEntityDescription.entityForName("Message", inManagedObjectContext: dataStore.managedObjectContext)
        
        if let messageDescription = messageDescription {
            
            let message = Message(entity: messageDescription, insertIntoManagedObjectContext: dataStore.managedObjectContext)
            message.content = chatTextField.text
            message.createdAt = NSDate()
        }
        dataStore.saveContext()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
