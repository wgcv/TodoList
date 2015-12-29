//
//  TodoList.swift
//  MyTodoList
//
//  Created by Gustavo Cevallos on 12/26/15.
//  Copyright © 2015 WGCV. All rights reserved.
//

import UIKit

class TodoList: NSObject {
    var items: [TodoItem] = []
    private let fileURL: NSURL = {
        let fileManager = NSFileManager.defaultManager()
        let documentDirectoryURLs = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask) as [NSURL]
        let documentDirectoryURL = documentDirectoryURLs.first!
        print("path de documents \(documentDirectoryURL)")
        return documentDirectoryURL.URLByAppendingPathComponent("todolist.plist")
        
    }()
    
    override init() {
        super.init()
        loadItems()
    }
    
    func addItem(item: TodoItem){
        items.append(item)
        saveItems()
    }
    func saveItems(){
        let itemsArray = items as NSArray
      
        if  NSKeyedArchiver.archiveRootObject(itemsArray, toFile: self.fileURL.path!){
            print("Guardado")
        }else{
            print("No guardado")
        }
    }
    func loadItems(){
        if let itemsArray = NSKeyedUnarchiver.unarchiveObjectWithFile(self.fileURL.path!){
            self.items = itemsArray as! [TodoItem]
        }
        
    }
    func getItem(indice: Int) -> TodoItem {
        return items[indice]
        
    }
}
extension TodoList : UITableViewDataSource{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let item = items[indexPath.row]
        cell.textLabel!.text = item.todo
        return cell
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        items.removeAtIndex(indexPath.row)
        saveItems()
        tableView.endUpdates()
    }
}