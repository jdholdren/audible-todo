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
    
    var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load todo items
        let todoItems = self.loadTodos()
        if (todoItems != nil) {
            self.todos = todoItems!
            
            // Load the counter as well
            let loadedCounter = self.loadCounter()
            if (loadedCounter != nil) {
                self.counter = loadedCounter!
            }
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
    
    // For creation
    @IBAction func unwindToList(segue: UIStoryboardSegue) {
        // Update the counter
        self.counter += 1
        
        // Trigger a save of all of the todo items
        self.saveData()
    }
    
    // For deletion or edits
    @IBAction func unwindFromDetails(segue: UIStoryboardSegue) {
        self.tableView.reloadData()
        self.saveData()
    }
    
    func saveData() {
        // Save the todos
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.todos, toFile: TodoItem.ArchiveURL.path!)
        if (!isSuccessfulSave) {
            print("Unable to save todo items")
        } else {
            print("Sucessful Save")
        }
        
        // Save the current index
        let isSuccessfulCounterSave = NSKeyedArchiver.archiveRootObject(self.counter, toFile: TodoItem.CounterURL.path!)
        if (!isSuccessfulCounterSave) {
            print("Unable to save counter")
        } else {
            print("Sucessful Save")
        }
    }
    
    // Grabs a todo item based on *its* index
    func getIndexedItem(index: Int) -> Int {
        for (var i = 0, length = self.todos.count; i < length; i += 1) {
            if (self.todos[i].index == index) {
                return i
            }
        }
        
        return -1
    }
    
    func loadTodos() -> [TodoItem]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TodoItem.ArchiveURL.path!) as? [TodoItem]
    }
    
    func loadCounter() -> Int? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(TodoItem.CounterURL.path!) as? Int
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "DetailsSegue") {
            // We know that it's a details controller as the dest
            let destController = segue.destinationViewController as! DetailsTableViewController
            let selectedCell = sender as! TodoItemCell
            let indexPath = tableView.indexPathForCell(selectedCell)!
            let todoItem = self.todos[indexPath.row]
            
            destController.todo = todoItem
        } else {
            // It's the create controller
            let destController = segue.destinationViewController as! CreateControllerViewController
            destController.nextIndex = self.counter + 1
        }
    }

}
