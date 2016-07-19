//
//  ViewController.swift
//  HostTools
//
//  Created by Summer on 16/5/19.
//  Copyright © 2016年 Summer. All rights reserved.
//

import Cocoa
import AppKit

let HostStoreKey = "HostStoreKey"

class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource{
    
    var dataHosts = [SZHostsModel]();//非空 相当于 !
    var editingModel : SZHostsModel?;
    
    @IBOutlet weak var tableHosts: NSTableView!{
        didSet{
            self.tableHosts.registerNib(NSNib(nibNamed: "HostListCell", bundle: nil)!, forIdentifier: "HostListCellIndentifier")
        }
    }
    
    @IBOutlet var txtHostContent: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.readHosts();
        let systemHost = self.getSystemHostModel();
        if (systemHost != nil){
            editingModel = systemHost;
            txtHostContent.string = systemHost?.hostContent;
        }
        tableHosts.reloadData();
        
        tableHosts.target = self;
        tableHosts.doubleAction = "doubleSelectedHost:";
        
        self.didPressedShowLocalHost("");
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func doubleSelectedHost(sender : AnyObject){
        let selectedRow = self.tableHosts.clickedRow;
        if selectedRow >= 0{
            let selectedModel = dataHosts[selectedRow];
            
//            let content = selectedModel.hostContent;
            if (/*(content?.isEmpty) != nil*/true){
                self.resetDoubleClickedHostListData();
                selectedModel.bDoubleSelected = true;
                selectedModel.bSingleSelected = true;
                editingModel = selectedModel;
                txtHostContent.string = selectedModel.hostContent;//修改右边显示的host文件
                self.saveHosts();//存储文件
                
                ShellTool.changeHosts(txtHostContent.string!);
            }
//            else{
//                let alert = NSAlert();
//                alert.messageText = "请输入host内容";
//                alert.addButtonWithTitle("确定");
//                alert.beginSheetModalForWindow(NSApp.mainWindow!) { (NSModalResponse selectedButton) -> Void in
//                    
//                }
//            }
        }
    }

    @IBAction func didPressedAddHost(sender: AnyObject) {
        
        let txtHostName = NSTextField();
        txtHostName.frame = CGRectMake(0, 0, 300, 24);
        txtHostName.placeholderString = "请输入host名称";

        let alertName = NSAlert();
        alertName.messageText = "请输入名称";
        alertName.addButtonWithTitle("确定");
        alertName.addButtonWithTitle("取消");
        alertName.accessoryView = txtHostName;
        alertName.beginSheetModalForWindow(NSApp.mainWindow!) { (NSModalResponse selectedButton) -> Void in
            if selectedButton == NSAlertFirstButtonReturn{
                self.addHost(txtHostName.stringValue);
                self.txtHostContent.string = "";
            }else if selectedButton == NSAlertSecondButtonReturn{
            }
        }
    }
    
    @IBAction func didPressedShowLocalHost(sender: AnyObject) {
        let localHostContent = ShellTool.readHosts();//读取本地host数据
        
//        print("localHost : \(localHostContent!)");
        
        txtHostContent.string = localHostContent!;

    }
    
    func addHost(hostName: String) {
        self.resetHostListData();
        
        let model = SZHostsModel();
        model.bSingleSelected = true;
        model.hostName = hostName;
        
        dataHosts += [model];
        editingModel = model;
        tableHosts.reloadData();
    }
    
    func getSystemHostModel() -> SZHostsModel?{
        var systemModel : SZHostsModel?;
        for item in dataHosts{
            if (item.bDoubleSelected == true) {
                systemModel = item;
            }
        }
        
        if systemModel == nil {
            if dataHosts.count > 0{
                systemModel = dataHosts.first;//如果没有选择， 则取第一个
                systemModel?.bDoubleSelected = true;
            }else{
                return nil;
            }
        }
        return systemModel;
    }
    
    func removeSelectedHost() {
        var selectModel : SZHostsModel?;
        for item in dataHosts{
            if (item.bSingleSelected == true) {
                selectModel = item;
            }
        }
        if (selectModel != nil) {
            self.removeHost(selectModel!);
        }
        
        self.saveHosts();//存储文件
    }
    
    func removeHost(removeModel : SZHostsModel) {
        dataHosts.removeAtIndex(dataHosts.indexOf(removeModel)!);
        
        tableHosts.reloadData();
        
        
    }
    
    func resetHostListData() {
        for model in dataHosts{
            model.bSingleSelected = false;
        }
    }
    
    func resetDoubleClickedHostListData(){
        self.resetHostListData();
        
        for model in dataHosts{
            model.bDoubleSelected = false;
        }
    }
    
    
    @IBAction func didPressedBtnRunShell(sender: AnyObject) {
        let content = txtHostContent.string;//解包
        if !(content!.isEmpty){
            editingModel?.hostContent = txtHostContent!.string;
            
            
        }else{
            editingModel?.hostContent = "";
//            let alert = NSAlert();
//            alert.messageText = "请输入host内容";
//            alert.addButtonWithTitle("确定");
//            alert.beginSheetModalForWindow(NSApp.mainWindow!) { (NSModalResponse selectedButton) -> Void in
//                
//            }
        }
        self.saveHosts();
        if editingModel?.bDoubleSelected == true {
            ShellTool.changeHosts(txtHostContent.string!);
        }
    }
    
    func saveHosts(){
        if self.dataHosts.count > 0{
            let data = NSKeyedArchiver.archivedDataWithRootObject(self.dataHosts);
            NSUserDefaults.standardUserDefaults().setObject(data, forKey:HostStoreKey);
            NSUserDefaults.standardUserDefaults().synchronize();
        }
    }
    
    func readHosts(){
        if let data = NSUserDefaults.standardUserDefaults().objectForKey(HostStoreKey) as? NSData{
            dataHosts = (NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [SZHostsModel])!;
        }
    }
    
    @IBAction func didPressedBtnDelete(sender: AnyObject) {
        self.removeSelectedHost();
    }
    
    override func keyDown(theEvent: NSEvent) {
        super.keyDown(theEvent);
        
        if theEvent.keyCode == 51 {//Dele键
            self.removeSelectedHost();
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int{
        return dataHosts.count;
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeViewWithIdentifier("HostListCellIndentifier", owner: self);
        if tableColumn!.identifier == "HostListCellIndentifier" {
            let model = dataHosts[row];
            let labelCellView = cellView as? HostListCell;
            labelCellView?.wantsLayer = true;
            labelCellView?.updateInfo(model);
        }
        return cellView;
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        self.resetHostListData();
        let selectRow = self.tableHosts.selectedRow;
        if selectRow >= 0{
            let selectModel = dataHosts[selectRow];
            if let content = selectModel.hostContent{
                txtHostContent.string = content;
            }else{
                txtHostContent.string = "";
            }
            selectModel.bSingleSelected = true;
            editingModel = selectModel;
            tableHosts.reloadData();
        }
    
    }
}

