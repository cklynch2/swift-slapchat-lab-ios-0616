//
//  TableViewController.swift
//  SlapChat
//
//  Created by susan lovaglio on 7/16/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    // This is a local messages property, which will ensure that we do not reload Message objects that have already been added to the data store.
    var messages = [Message]()
    
    let dataStore = DataStore.sharedDataStore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch existing data from dataStore and add it to the local messages array property.
        dataStore.fetchData()
        messages = dataStore.messages
        
        // If the local messages array is still empty, then the test data has not been added yet. Therefore, call generateTestData() and add messages to the local array.
        if messages.isEmpty {
            generateTestData()
            messages = dataStore.messages
        }
        print(messages)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        dataStore.fetchData()
        messages = dataStore.messages
        tableView.reloadData()
    }
    
    func generateTestData() {
        let messageDescription = NSEntityDescription.entityForName("Message", inManagedObjectContext: dataStore.managedObjectContext)
        
        if let message = messageDescription {
            
            let message1 = Message(entity: message, insertIntoManagedObjectContext: dataStore.managedObjectContext)
            message1.content = "Core Data is rocking my brain!"
            message1.createdAt = NSDate()
            
            dataStore.managedObjectContext.insertObject(message1)
            
            let message2 = Message(entity: message, insertIntoManagedObjectContext: dataStore.managedObjectContext)
            
            message2.content = "Turtle turtle turtle!"
            message2.createdAt = NSDate()
            
            dataStore.managedObjectContext.insertObject(message2)
            
            dataStore.saveContext()
            dataStore.fetchData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.messages.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("basicCell")
        
        if let cellLabel = cell?.textLabel {
            cellLabel.text = dataStore.messages[indexPath.row].content
        }
        return cell!
    }
    
    @IBAction func sortMostRecentTapped(sender: AnyObject) {
        
        // This says to sort the messages array such that, for any two messages, the left has a more recent date than the right.
        dataStore.messages.sortInPlace({ $0.createdAt < $1.createdAt })
        dataStore.fetchData()
        messages = dataStore.messages
        tableView.reloadData()
    }
}


// In order to sort dates more intuitively, you can make custom operator functions and have the NSDate class adhere to Comparable protocol...
public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs === rhs || lhs.compare(rhs) == .OrderedSame
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}

public func >(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedDescending
}

extension NSDate: Comparable {}
