//
//  DetailsTableViewController.swift
//  TodoAudible
//
//  Created by James Holdren on 4/19/16.
//  Copyright © 2016 James Holdren. All rights reserved.
//

import UIKit
import AVFoundation

class DetailsTableViewController: UITableViewController {
    
    // The object being displayed
    var todo: TodoItem!

    @IBOutlet weak var recordingButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the fields
        self.nameTextField.text = self.todo.name
        
        if (self.todo.recording == nil) {
            // Hide the playback button
            self.recordingButton.hidden = true
        } else {
            self.loadAudio()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAudio() {
        do {
            try player = AVAudioPlayer(contentsOfURL: self.getURLForTodoItem(self.todo))
        } catch {
            print("Could not load audio file")
        }
    }
    
    func getURLForTodoItem(item: TodoItem) -> NSURL {
        let audioFilename = self.getDocumentsDirectory()
        let recordingURL = NSURL(fileURLWithPath: audioFilename).URLByAppendingPathComponent("recording_\(item.index).m4a")
        
        return recordingURL
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func saveChanges() {
        self.performSegueWithIdentifier("UpdateUnwindSegue", sender: self)
    }

    @IBAction func deleteItem(sender: AnyObject) {
        self.performSegueWithIdentifier("DeletionUnwindSegue", sender: self)
    }
    
    @IBAction func recordingClicked() {
        if (self.player.playing) {
            self.player.stop()
        } else {
            self.player.play()
        }
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
