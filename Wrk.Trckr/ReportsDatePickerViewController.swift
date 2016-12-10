//
//  ReportsDatePickerViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 06/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class ReportsDatePickerViewController: UIViewController {

    var jobs: [Jobtitle] = []
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    var savedStart: NSDate?
    var savedEnd: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // NOT WORKING YET, WTF!
        //
        //  goddamn.
        if (savedStart != nil) && (savedEnd != nil) {
            self.endDate.setDate(savedEnd! as Date, animated: false)
            self.startDate.setDate(savedStart! as Date, animated: false)
            print("segue did set dates")
        }
        
        print("got this many jobs at datepicker start", jobs.count)

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
        if segue.identifier == "exportWorktimes" {
            let controller = segue.destination as! ExportViewController
            let start = startDate.date as NSDate
            let end = endDate.date as NSDate
            controller.startDate = start
            controller.endDate = end
            controller.jobs = jobs
            print("this many stuff at datepicker segue", jobs.count, startDate.date, endDate.date)
        }
    }
}
