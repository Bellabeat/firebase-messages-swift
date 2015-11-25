//
//  BBSRoomModel.swift
//  Social
//
//  Created by Ivan Fabijanović on 24/11/15.
//  Copyright © 2015 Bellabeat. All rights reserved.
//

internal let KeyRoomName = "name"
internal let KeyRoomType = "type"

public class BBSRoomModel: BBSModelBase {

    // MARK: - Properties
    
    public var name = Variable<String>("")
    public var type = Variable<String>("")
    
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
        self.name.value = object.objectForKey(KeyRoomName) as? String ?? ""
        self.type.value = object.objectForKey(KeyRoomType) as? String ?? ""
    }
    
    public override func serialize() -> [NSObject: AnyObject] {
        return [
            KeyRoomName: self.name.value,
            KeyRoomType: self.type.value
        ]
    }
    
}
