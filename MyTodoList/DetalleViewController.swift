//
//  DetalleViewController.swift
//  MyTodoList
//
//  Created by Gustavo Cevallos on 12/27/15.
//  Copyright © 2015 WGCV. All rights reserved.
//

import UIKit

class DetalleViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate	{
    var item: TodoItem?
    var todoList: TodoList?

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dayPicker: UIDatePicker!
    @IBAction func addImage(sender: UIBarButtonItem) {
       let imagePickerController =  UIImagePickerController()
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        imagePickerController.delegate = self
    }
    
    @IBAction func addNotification(sender: UIBarButtonItem) {
        if let dateString = self.dateLabel.text{
            if let date = parseDate(dateString){
               scheduleNotification((item?.todo)!, date: date)
            }
        }
        API.save(item!, todoList: todoList!) { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
            if let err = error {
                self.showError(err.description)
            }else{
               self.navigationController?.popToRootViewControllerAnimated(true)

            }
                 })
        }
    }
    
    func showError(error: String){
        let alert = UIAlertController(title: "UPS", message: "No pudimos guardar los cambios revisa la coneccion a internet \(error)", preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { (UIAlertAction) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
        
        
    }
    func scheduleNotification(message: String, date: NSDate){
        let localnotification = UILocalNotification()
        localnotification.fireDate = date
        localnotification.timeZone = NSTimeZone.defaultTimeZone()
        localnotification.alertBody = message
        localnotification.alertTitle = "Recuarda esta tarea"
        localnotification.applicationIconBadgeNumber += 1;
        UIApplication.sharedApplication().scheduleLocalNotification(localnotification)
        
    }
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func daySelected(sender: UIDatePicker) {
        print("Fecha seleccionada: \(sender.date)")
        self.dateLabel.text = formatDay(sender.date)
        item?.dueDate=sender.date
        todoList?.saveItems()
        togglerDayPicker()
    }
    func parseDate (string: String) -> NSDate? {
        let parse = NSDateFormatter()
        parse.dateFormat = "dd/MM/yyy HH:mm"
        return parse.dateFromString(string)
    }
    func formatDay (date: NSDate) -> String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM/yyy HH:mm"
        return formatter.stringFromDate(date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(item)")
        let tabGestureRcongnizer = UITapGestureRecognizer()
        tabGestureRcongnizer.numberOfTapsRequired = 1
        tabGestureRcongnizer.numberOfTouchesRequired = 1
        tabGestureRcongnizer.addTarget(self, action: "togglerDayPicker")
        self.dateLabel.addGestureRecognizer(tabGestureRcongnizer)
        self.dateLabel.userInteractionEnabled = true
        showItem()
        gestureReconicerToImage()
        // Do any additional setup after loading the view.
    }
    func gestureReconicerToImage(){
        let gr = UITapGestureRecognizer()
        gr.numberOfTapsRequired = 1
        gr.numberOfTouchesRequired = 1
        gr.addTarget(self, action: "rotater")
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(gr)
    }
    
    func rotater(){
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = M_PI * 2.0
        animation.duration = 1
        animation.repeatCount = 6
        self.imageView.layer.addAnimation(animation, forKey: "Rotacion")
    }
    func showItem(){
        self.descriptionLabel.text = item?.todo
        if let date = item?.dueDate {
            dateLabel.text = formatDay (date)
        }
        
        if let image = item?.image {
            imageView.image = image
        }
    }
    func togglerDayPicker(){
        if dayPicker.hidden{
            self.fadeInDatePicker()
        }else{
            self.fadeOutDatePicker()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Image Picker Controler Method
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
       
            self.imageView.image = image
            self.item?.image = image
        self.todoList?.saveItems()
        
        self.dismissViewControllerAnimated(true, completion: nil )
        
    }
    
    //MARK: ANIMACIONES
    func fadeInDatePicker(){
        self.dayPicker.alpha = 0
        self.dayPicker.hidden = false
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.dayPicker.alpha = 1
            self.imageView.alpha = 0

            })
    }
    func fadeOutDatePicker(){
        self.dayPicker.alpha = 1
        self.dayPicker.hidden = false
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.dayPicker.alpha = 0
            self.imageView.alpha = 1
            }) { (complete) -> Void in
                
                if complete
                {
                    self.dayPicker.hidden = true
                    
                }
        }
       
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
