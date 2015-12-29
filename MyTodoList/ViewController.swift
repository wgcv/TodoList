//
//  ViewController.swift
//  MyTodoList
//
//  Created by Gustavo Cevallos on 12/25/15.
//  Copyright © 2015 WGCV. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate, UITextFieldDelegate{
    @IBOutlet weak var itemTextFeild: UITextField!
    @IBOutlet weak var tableView: UITableView!
    static let MAX_TEXT_SIZE = 50
    
    let todoList = TodoList()
    
    var selectedItem: TodoItem?
    
    @IBAction func addButtonPressed(sender: UIButton){
        print("Agregando un elemento a la lista \(itemTextFeild.text!)")
        let todoItem = TodoItem()
        todoItem.todo = itemTextFeild.text!
        todoList.addItem(todoItem)
        tableView.reloadData()
        self.itemTextFeild.resignFirstResponder()

        itemTextFeild.text=""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = todoList
        tableView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Metodos del table view Delegate
    func scrollViewDidScroll(scrollView: UIScrollView){
        self.itemTextFeild.resignFirstResponder()
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = self.todoList.getItem(indexPath.row)
       self.performSegueWithIdentifier("showItem", sender: self)
       // let detailVC = DetalleViewController()
       // detailVC.item = self.selectedItem
        //self.navigationController?.pushViewController(detailVC, animated: true)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detalleViewController = segue.destinationViewController as? DetalleViewController {
            detalleViewController.item = self.selectedItem
            detalleViewController.todoList = self.todoList

        }
        
    }
    
    //MARK: Metodos del Text Field Delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let tareaString = textField.text! as NSString
            let updateString = tareaString.stringByReplacingCharactersInRange(range, withString: string)
            return updateString.characters.count <= ViewController.MAX_TEXT_SIZE
        
    }
}

