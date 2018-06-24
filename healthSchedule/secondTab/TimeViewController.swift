//
//  TimeViewController.swift
//  healthSchedule
//
//  Created by SWUCOMPUTER on 2018. 6. 2..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData
class TimeViewController: UIViewController {

    
    @IBOutlet var hLab: UILabel!
    @IBOutlet var mLab: UILabel!
    @IBOutlet var sLab: UILabel!
    @IBOutlet var doneView: UIView!
    var doTimer: NSManagedObject?
    var seconds = 5
    var tmpSec = 5
    var hour = 0
    var min = 0
    var sec = 0
    var timer = Timer()
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    @IBAction func start(_ sender: UIButton)
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimeViewController.counter), userInfo: nil, repeats: true)
    }
    
    @objc func counter()
    {
        seconds -= 1
        timeString(time: seconds)
        
        if (seconds == 0)
        {
            timer.invalidate()
            doneView.isHidden=false
        }
    }
    
    @IBAction func stop(_ sender: AnyObject)
    {
        timer.invalidate()
        seconds = tmpSec
        timeString(time: seconds)

    }
    
    @IBAction func doneBtn(_ sender: Any) {
        doTimer?.setValue(true, forKey: "isDone")
        do {
            let context = self.getContext()
            try context.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        showToast(message: "참 잘했어요!")
    }
    func timeString(time:Int) {
        
        hour = seconds/3600
        min = seconds / 60 % 60
        sec = seconds % 60
        hLab.text = String(format:"%02i", hour)
        mLab.text = String(format:"%02i", min)
        sLab.text = String(format:"%02i", sec)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        doneView.isHidden = true
        if let list = doTimer {
            seconds = Int((list.value(forKey: "time") as? String)!)!
            tmpSec = seconds
        }
        timeString(time: seconds)
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
