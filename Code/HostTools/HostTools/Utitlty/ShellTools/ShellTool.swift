//
//  ShellTool.swift
//  HostTools
//
//  Created by Summer on 16/5/20.
//  Copyright © 2016年 Summer. All rights reserved.
//

import Foundation

class ShellTool {
    class func runCommand(path : String, args : [String]) -> (output: NSString, error: NSString, exitCode: Int32) {
        let task = NSTask()
        task.launchPath = path
        task.arguments = args
        
        let outpipe = NSPipe()
        task.standardOutput = outpipe
        let errpipe = NSPipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: outdata, encoding:  NSUTF8StringEncoding)
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        let error_output = NSString(data: errdata, encoding: NSUTF8StringEncoding)
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output!, error_output!, status)
    }
    
    //修改hosts
    class func changeHosts(hosts : String) -> (Int32) {
        //
        let convertedPath = String.init("/etc/hosts".utf8);
        
        let task = NSTask()
        task.launchPath = "/usr/libexec/authopen";
        task.arguments = ["-c", "-w", convertedPath!];
        
        let pipe = NSPipe()
        let writeHandle = pipe.fileHandleForWriting;
        task.standardInput = pipe;
        
        task.launch()
        
        let data = hosts.dataUsingEncoding(NSUTF8StringEncoding);
        writeHandle.writeData(data!);
        writeHandle.closeFile();
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (status)
    }
    
    //读取hosts
    class func readHosts() -> String?{
        
        let hostData = NSData.dataWithContentsOfMappedFile("/etc/hosts") as? NSData;
        let output = String(data: hostData!, encoding:  NSUTF8StringEncoding)
        
        return output;
    }

}