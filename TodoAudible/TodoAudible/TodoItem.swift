//
//  TodoItem.swift
//  TodoAudible
//
//  Created by James Holdren on 4/19/16.
//  Copyright © 2016 James Holdren. All rights reserved.
//

import UIKit

class TodoItem: NSObject, NSCoding {
    
    // For persistence
    struct PropertyKey {
        static let nameKey = "name"
        static let indexKey = "index"
        
        // For the counter
        static let counterKey = "counter"
    }
    
    var name: String
    var index: Int
    
    init(name: String, index: Int) {
        self.index = index
        self.name = name
        
        // Call the super's initializer
        super.init()
    }
    
    // MARK: NSCODING
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(self.index, forKey: PropertyKey.indexKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let index = aDecoder.decodeObjectForKey(PropertyKey.indexKey) as! Int
        
        // Call initializer
        self.init(name: name, index: index)
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("todos")
    static let CounterURL = DocumentsDirectory.URLByAppendingPathComponent("counter")
}
