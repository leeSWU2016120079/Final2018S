//
//  AddListViewController.swift
//  healthSchedule
//
//  Created by SWUCOMPUTER on 2018. 6. 2..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class AddListViewController: UIViewController , UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var hourArray: [Int] = []
    var minArray: [Int] = []
    var secArray: [Int] = []
    var day:String = ""
    var time:String = ""
    
    @IBOutlet var hourPic: UIPickerView!
    @IBOutlet var minPic: UIPickerView!
    @IBOutlet var secPic: UIPickerView!
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView == hourPic) {
            return hourArray.count
        }
        else if(pickerView == minPic) {
            return minArray.count
        }
        else if(pickerView == secPic) {
            return secArray.count
        }
        else {return 0}
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView == hourPic) {
            return String(format:"%02i", hourArray[row])
        }
        else if(pickerView == minPic) {
            return String(format:"%02i", minArray[row])
        }
        else if(pickerView == secPic) {
            return String(format:"%02i", secArray[row])
        }
        else {return nil}
    }
    
    @IBOutlet var todoName: UITextField!
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveBtn(_ sender: Any) {
        let todo = todoName.text
        let hour: Int = hourArray[self.hourPic.selectedRow(inComponent: 0)]
        let min: Int = minArray[self.minPic.selectedRow(inComponent: 0)]
        let sec: Int = secArray[self.secPic.selectedRow(inComponent: 0)]
        let time = String(hour*3600 + min*60 + sec)
        if(Int(time) != 0 && todo != ""){
            let context = getContext()
            let entity = NSEntityDescription.entity(forEntityName: day, in: context)
            let object = NSManagedObject(entity: entity!, insertInto: context)
            object.setValue(todo, forKey: "todo")
            object.setValue(time, forKey: "time")
            do {
                try context.save()
                showToast(message: "저장되었습니다.")
                print("saved!")
            } catch let error as NSError {
                print("Could not save \(error), \(error.userInfo)") }
        }
        else {
            if(Int(time) == 0){
                showToast(message: "시간을 입력하세요")
            }
            else {
                showToast(message: "할일을 입력하세요")
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...10 {
        hourArray.append(i)
        }
        for i in 0...59 {
            minArray.append(i)
            secArray.append(i)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
