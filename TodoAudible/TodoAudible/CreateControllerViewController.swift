//
//  CreateControllerViewController.swift
//  TodoAudible
//
//  Created by James Holdren on 4/19/16.
//  Copyright © 2016 James Holdren. All rights reserved.
//

import UIKit

class CreateControllerViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Create the todo item
        let todoItem = self.createItem()
        let destController = segue.destinationViewController as! ListControllerTableViewController
        
        // Set the index on the item so that the correct one gets updated later
        todoItem.index = destController.counter + 1
        
        destController.todos.append(todoItem)
        destController.tableView.reloadData()
    }
    
    @IBAction func createItemAndUnwind(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToList", sender: self)
    }

    /**
    * Saves the item
    */
    func createItem() -> TodoItem {
        // Grab the name
        let name = self.nameTextField.text! as String
        
        return TodoItem(name: name, index: 0)
    }
}
