//
//  BBSGlobalModel.swift
//  Social
//
//  Created by Ivan Fabijanović on 25/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

internal let KeyGlobalNote = "note"

public class BBSGlobalModel: BBSModelBase {
    
    // MARK: - Properties
    
    public var note = Variable<String>("")
    
    // MARK: - Init
    
    public override init() {
        super.init()
    }
    
    deinit {
        print("BBSGlobalModel deinit")
    }
    
    // MARK: - Overrides
    
    public override func updateWithObject(object: AnyObject) {
        self.note.value = object.objectForKey(KeyRoomNote) as? String ?? ""
    }
    
    public override func serialize() -> [NSObject: AnyObject] {
        return [
            KeyRoomNote: self.note.value
        ]
    }
    
}
