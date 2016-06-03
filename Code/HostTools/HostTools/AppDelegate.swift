//
//  AppDelegate.swift
//  HostTools
//
//  Created by Summer on 16/5/19.
//  Copyright © 2016年 Summer. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    /*
    -(BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
    
    {
    
    [window makeKeyAndOrderFront:nil];
    
    return YES;
    
    }
*/
    func applicationShouldHandleReopen(sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        sender.windows.first?.makeKeyAndOrderFront(nil);
        return true;
    }
    
}

