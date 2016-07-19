//
//  SZHostsModel.swift
//  HostTools
//
//  Created by Summer on 16/5/19.
//  Copyright © 2016年 Summer. All rights reserved.
//

import Cocoa
import Foundation

class SZHostsModel : NSObject, NSCoding {
    var hostName : String?
    var hostContent : String?
    var bSingleSelected : Bool = false//单机选中(当前编辑的host)
    var bDoubleSelected : Bool = false//双击选中(当前系统的host)
    var normalTextColor : NSColor = NSColor.grayColor();
    var normalBgColor : NSColor = NSColor.init(deviceRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0);
    
    var doubleSelectedTextColor : NSColor = NSColor.blackColor();
    var doubleSelectedBgColor : NSColor = NSColor.init(deviceRed: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0);
    
    var singleSelectedTextColor : NSColor = NSColor.whiteColor();
    var singleSelectedBgColor : NSColor = NSColor.init(deviceRed: 40.0/255.0, green: 125.0/255.0, blue: 253.0/255.0, alpha: 1.0);
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.hostName = decoder.decodeObjectForKey("hostName") as? String
        self.hostContent = decoder.decodeObjectForKey("hostContent") as? String
        self.bDoubleSelected = decoder.decodeBoolForKey("bDoubleSelected") ;
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.hostName, forKey: "hostName");
        aCoder.encodeObject(self.hostContent, forKey: "hostContent");
        aCoder.encodeBool(self.bDoubleSelected, forKey: "bDoubleSelected");
    }
    
    
}

