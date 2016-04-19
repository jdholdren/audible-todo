//
//  ListControllerTableViewController.swift
//  TodoAudible
//
//  Created by James Holdren on 4/19/16.
//  Copyright © 2016 James Holdren. All rights reserved.
//

import UIKit

class ListControllerTableViewController: UITableViewController {
    
    // The list of todo items
    var todos = [TodoItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load todo items
        let todoItems = self.loadTodos()
        if (todoItems != nil) {
            self.todos = todoItems!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Table logic

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "TodoItemCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! TodoItemCell
        let todoItem = self.todos[indexPath.row]

        // Map the traits from the model to the cell
        cell.todoName.text = todoItem.name
        
        return cell
    }
    
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        // Trigger a save of all of the todo items
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.todos, toFile: TodoItem.ArchiveURL.path!)
        if (!isSuccessfulSave) {
            print("Unable to save todo items")
        } else {
            print("Sucessful Save")
        }
    }
    
    func loadTodos() -> [TodoItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TodoItem.ArchiveURL.path!) as? [TodoItem]
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
