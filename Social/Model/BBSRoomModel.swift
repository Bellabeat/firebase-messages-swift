//
//  BBSRoomModel.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

public class BBSRoomModel: BBSModelBase {

    // MARK: - Properties
    
    public var name: String = ""
    public var type: String = ""
    
    // MARK: - Init
    
    public init(key: String, value: AnyObject) {
        super.init()
        self.key = key
        self.updateWithObject(value)
    }
    
    deinit {
        print("BBSRoomModel deinit")
    }
    
    // MARK: - Overrides
    
    public override func updateWithObject(object: AnyObject) {
        if let name = object.objectForKey("name") as? String {
            self.name = name
        }
        if let type = object.objectForKey("type") as? String {
            self.type = type
        }
    }
    
    public override func serialize() -> AnyObject {
        return [
            "name": self.name,
            "type": self.type
        ]
    }
    
}
