//
//  API.swift
//  MyTodoList
//
//  Created by Gustavo Cevallos on 12/28/15.
//  Copyright © 2015 WGCV. All rights reserved.
//

import UIKit

class API {
    class func uniqueUsername() -> String {
    
        if let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as? String {
            return username
        }else{
            let username = generateUsername()
            NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
             return username
        }
       
    }


class func generateUsername() ->String {
    let uuid = NSUUID().UUIDString
    
    return (uuid as NSString).substringToIndex(5)
}

class func save(item: TodoItem, todoList: TodoList, responseBlock: (NSError?)-> Void ){
    let sessioon = NSURLSession.sharedSession()
    let url = NSURL(string: "https://pendientesapp.herokuapp.com/todo")!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    var diccionary: Dictionary<String, AnyObject> = ["Message": item.todo!, "user": self.uniqueUsername() ]
    if let date = item.dueDate {
        let format = NSDateFormatter()
        format.dateFormat = " dd/MM/yyyy HH:mm"
        diccionary["dueDate"] = format.stringFromDate(date)
    }
    if let identifier = item.id {
        diccionary["id"] = NSNumber(longLong: identifier)
        
    }
    let data = try! NSJSONSerialization.dataWithJSONObject(diccionary, options: NSJSONWritingOptions.PrettyPrinted)
    request.HTTPBody = data
    
    let task = sessioon.dataTaskWithRequest(request){ (data, response, error) -> Void in
        if let err = error{
            responseBlock(err)
        }else{
            if let d = data {
                let result = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments)
                print("La respuesta viene en result \(result)")
                if let id = result["id"] as? Int64 {
                    item.id = id
                    todoList.saveItems()
                }
                
            }
        }
    }
    task.resume()

    }
}