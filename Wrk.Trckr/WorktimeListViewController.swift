//
//  WorktimelistViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 06/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit
import CoreData

class WorktimeListViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var worktimeTableView: UITableView!
    weak var job: Jobtitle!
    var worktimes: [Worktime] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        worktimeTableView.register(UINib(nibName: "WorktimeCell", bundle: nil), forCellReuseIdentifier: "WorktimeCell")
        // title = "Hours for " + job.name as! String
        // WHY WONT THIS WORK!
        // worktimes = job.worktimes as! [Worktime]
        worktimes = job.finishedWorktimes()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worktimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = worktimeTableView.dequeueReusableCell(withIdentifier: "WorktimeCell", for: indexPath) as! WorktimeCell
        let workrow = worktimes[indexPath.row]
        cell.jobtitle.isHidden = true
        cell.setDatestringFromDate(workrow.start! as Date)
        cell.setHoursFromInterval(workrow.duration())
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
        if segue.identifier == "editWorktime" {
            let controller = segue.destination as! WorktimeEditViewController
            controller.worktime = worktimes[(worktimeTableView.indexPathForSelectedRow?.row)!]
        }
    }

}
