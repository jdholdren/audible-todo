//
//  CreateControllerViewController.swift
//  TodoAudible
//
//  Created by James Holdren on 4/19/16.
//  Copyright © 2016 James Holdren. All rights reserved.
//

import UIKit
import AVFoundation

class CreateControllerViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var nextIndex: Int!
    var recordingURL: NSURL!
    var hasRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioFilename = self.getDocumentsDirectory()
        self.recordingURL = NSURL(fileURLWithPath: audioFilename).URLByAppendingPathComponent("recording_\(self.nextIndex).m4a")
        
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                dispatch_async(dispatch_get_main_queue()) {
                    if !allowed {
                        // failed to record!
                        self.recordButton.hidden = true
                    }
                }
            }
        } catch {
            // failed to record!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordingTapped() {
        if (self.audioRecorder == nil) {
            self.startRecording()
        } else {
            self.finishRecording(true)
        }
    }
    
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
            
        do {
            self.audioRecorder = try AVAudioRecorder(URL: self.recordingURL, settings:settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
            
            self.recordButton.setTitle("Tap to Stop", forState: .Normal)
        } catch {
            self.finishRecording(false)
        }
    }
    
    func finishRecording(success: Bool) {
        self.audioRecorder.stop()
        self.audioRecorder = nil
        
        if success {
            self.recordButton.setTitle("Tap to Re-record", forState: .Normal)
            self.hasRecording = true
        } else {
            self.recordButton.setTitle("Tap to Record", forState: .Normal)
        }
    }
    
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Create the todo item
        let todoItem = self.createItem()
        let destController = segue.destinationViewController as! ListControllerTableViewController
        
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
        let recording: NSURL?
        
        if (self.hasRecording) {
            recording = self.recordingURL
        } else {
            recording = nil
        }
        
        return TodoItem(name: name, index: self.nextIndex, recording: recording)
    }
}
