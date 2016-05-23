//
//  NSViewExtension.swift
//  HostTools
//
//  Created by Summer on 16/5/23.
//  Copyright © 2016年 Summer. All rights reserved.
//

import AppKit

extension NSView {
    
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(CGColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.CGColor
        }
    }
}