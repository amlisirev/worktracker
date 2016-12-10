//
//  WorktimeEditViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 06/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class WorktimeEditViewController: UIViewController {

    weak var worktime: Worktime!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    
    @IBAction func saveButton(_ sender: AnyObject) {
        worktime.start = startTime.date as NSDate
        worktime.end = endTime.date as NSDate
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title=worktime.start?.description
        startTime.setDate(worktime.start as! Date, animated: false)
        if worktime.end != nil {
            endTime.setDate(worktime.end as! Date, animated: false)
        } else {
            endTime.setDate(Date(), animated: false)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToWorktimeList" {
            let controller = segue.destination as! WorktimeListViewController
            controller.job = worktime.job
        }
    }

}
