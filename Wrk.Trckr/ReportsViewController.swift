//
//  ReportsViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 02/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var jobTableView: UITableView!
    
    var jobs: [Jobtitle] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reports"
        getData()
        jobTableView.register(UINib(nibName: "JobTitleCellView", bundle: nil), forCellReuseIdentifier: "JobCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getData() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            jobs = try managedContext.fetch(Jobtitle.fetchRequest())
        } catch {
            print("Fetching jobtitles failed")
        }
    }
    
    // TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let job = jobs[indexPath.row]
        let cell = jobTableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobTitleCell
        
        cell.jobtitle.text = job.name
        cell.jobcount.text = (job.worktimes?.count)?.description
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
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "chooseDates" {
            return (jobTableView.indexPathsForSelectedRows == nil) ? false : true
        }
        // basket return for all other segues
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseDates" {
            let controller = segue.destination as! ReportsDatePickerViewController
            let selectedIndexes = jobTableView.indexPathsForSelectedRows
            var selectedJobs: [Jobtitle] = []
            for item in selectedIndexes! {
                selectedJobs.append(jobs[item.row])
            }
            controller.jobs = selectedJobs
        }
    }
}
