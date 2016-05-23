//
//  HostListCell.swift
//  HostTools
//
//  Created by Summer on 16/5/21.
//  Copyright © 2016年 Summer. All rights reserved.
//

import Cocoa

class HostListCell: NSTableCellView {

    var hostModel : SZHostsModel?;
    
    @IBOutlet weak var txtHostName: NSTextField!
    
    
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        
//        NSColor.clearColor().set();
//        NSRectFill(dirtyRect);   //填充rect区域
        // Drawing code here.
//        self.setBgColor(NSColor.redColor());
//        self.wantsLayer = true;
//        self.wantsUpdateLayer = true;
    }
    
    func setBgColor(color : NSColor){
        color.set();
        NSRectFill(self.bounds);
    }
    
    func updateInfo(model : SZHostsModel?){
        hostModel = model;
        if let tempModel = hostModel{
            txtHostName.stringValue = tempModel.hostName!;
            
            self.backgroundColor = tempModel.normalBgColor;
            txtHostName.textColor = tempModel.normalTextColor;
            
            if tempModel.bSingleSelected{
                txtHostName.textColor = tempModel.singleSelectedTextColor;
                self.backgroundColor = tempModel.singleSelectedBgColor;
            }else if tempModel.bDoubleSelected{
                txtHostName.textColor = tempModel.doubleSelectedTextColor;
                self.backgroundColor = tempModel.doubleSelectedBgColor;
            }
        }
    }
    
    
}
