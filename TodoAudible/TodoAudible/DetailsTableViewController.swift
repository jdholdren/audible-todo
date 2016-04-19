//
//  DetailsTableViewController.swift
//  TodoAudible
//
//  Created by James Holdren on 4/19/16.
//  Copyright © 2016 James Holdren. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {
    
    // The object being displayed
    var todo: TodoItem!

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the fields
        self.nameTextField.text = self.todo.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveChanges() {
        self.performSegueWithIdentifier("UpdateUnwindSegue", sender: self)
    }

    @IBAction func deleteItem(sender: AnyObject) {
        self.performSegueWithIdentifier("DeletionUnwindSegue", sender: self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destController = segue.destinationViewController as! ListControllerTableViewController
        let index = destController.getIndexedItem(self.todo.index)
        
        if (segue.identifier! == "DeletionUnwindSegue") {
            // Delete the todo item from the controller
            destController.todos.removeAtIndex(index)
        } else {
            // Update properties on the object
            self.todo.name = self.nameTextField.text!
            
            // Switch out todo items (Update call)
            destController.todos[index] = self.todo
        }
    }

}
