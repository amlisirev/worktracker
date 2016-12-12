//
//  ExportViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 06/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit
import CoreData

class ExportViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var worktimeTableView: UITableView!
    weak var startDate: NSDate!
    weak var endDate: NSDate!
    var jobs: [Jobtitle] = []
    var work: [Worktime] = []
    
    @IBAction func Export(_ sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("you got this far, export!!!", jobs.count)
        worktimeTableView.register(UINib(nibName: "WorktimeCell", bundle: nil), forCellReuseIdentifier: "WorktimeCell")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sortBy = NSSortDescriptor(key: "start", ascending: false)
        let searchBy = NSPredicate(format: "(job IN %@)", jobs)
        let request: NSFetchRequest<Worktime> = Worktime.fetchRequest()
        request.sortDescriptors = [sortBy]
        request.predicate = searchBy
        do {
            work = try context.fetch(request)
        } catch {
            print("fetching worktimes failed")
        }
        worktimeTableView.reloadData()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return work.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worktimeTableView.dequeueReusableCell(withIdentifier: "WorktimeCell", for: indexPath) as! WorktimeCell
        let workrow = work[indexPath.row]
        cell.setDatestringFromDate(workrow.start as! Date)
        cell.jobtitle.text = workrow.job?.name
        if (workrow.end != nil) {
            cell.setHoursFromInterval(workrow.duration())
        } else {
            cell.hours.text = "ongoing"
        }
        return cell
        
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
        if segue.identifier == "backToDatepicker" {
            let controller = segue.destination as! ReportsDatePickerViewController
            controller.jobs = jobs
            controller.savedStart = startDate
            controller.savedEnd = endDate
            print("triggered back segue in export!")
        }
    }

}
