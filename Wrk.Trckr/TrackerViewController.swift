//
//  TrackerViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 02/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit
import CoreData

class TrackerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var jobTableView: UITableView!
    var jobs: [Jobtitle] = []
    var timer: Timer = Timer()
    weak var timerForJob: Jobtitle!
    weak var timerForWork: Worktime!
    
    @IBAction func addJob(_ sender: AnyObject) {
        let alert = UIAlertController(title: "New Job",
                                      message: "Add a new job",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
            let jobToSave = textField.text else {
                            return
                            }
            self.save(name: jobToSave)
            self.getData()
            self.reloadTable()
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Jobs"
        jobTableView.register(UINib(nibName: "JobTitleCellView", bundle: nil), forCellReuseIdentifier: "JobCell")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        timerDidChange()
        reloadTable()
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let job = jobs[indexPath.row]
        let cell = jobTableView.dequeueReusableCell(withIdentifier: "JobCell", for: indexPath) as! JobTitleCell
        
        cell.jobtitle.text = job.name
        cell.jobcount.text = (job.worktimes?.count)?.description
        if timer.isValid && (timerForWork?.job == job) {
            cell.jobtimer.isHidden = false
            cell.jobtimer.text = setCellTimeLabel(start: timerForWork.start! as Date)
        } else {
            cell.jobtimer.isHidden = true
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let jobToDelete = self.jobs[indexPath.row]
            context.delete(jobToDelete)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            self.getData()
            self.reloadTable()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") {(action, indexPath) in
            self.performSegue(withIdentifier: "worktimeListForJob", sender: indexPath)
        }
        
        return [deleteAction, editAction]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // user clicks on a row, start timer if not already started!
        let job = jobs[indexPath.row]
        stampCard(job: job)
        jobTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // user clicks on a timer row, disable timer!
        let job = jobs[indexPath.row]
        stampCard(job: job)
        jobTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    func stampCard(job: Jobtitle) {
        // stamps your card. if there are worktimes with no enddate, stamp enddates! if enddates exist, start new worktime and stamp start time.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sortByStart = NSSortDescriptor(key: "start", ascending: false)
        let searchByJob = NSPredicate(format: "(job == %@) AND (end == nil)", job)
        let requestForJob: NSFetchRequest<Worktime> = Worktime.fetchRequest()
        requestForJob.predicate = searchByJob
        requestForJob.sortDescriptors = [sortByStart]
        requestForJob.fetchLimit = 1
        
        let work:Worktime
        let stampdate = NSDate()
        do {
            let openjob = try context.fetch(requestForJob)
            
            if openjob.first != nil {
                work = openjob.first!
                work.end = stampdate
                print("STAMPED OUT", job.name)
            } else {
                let openjobs = openJobs()
                if !openjobs.isEmpty {
                    for item in openjobs {
                        item.end = stampdate
                    }
                    print("stamped out ", openjobs.count)
                }
                work = Worktime(context: context)
                work.job = job
                work.start = stampdate
                print("STAMPED IN")
            }
            } catch {
            print("failed to fetch")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        getData()
        timerDidChange()
    }
    

    
    // COREDATA STUFF
    //
    
    func reloadTable() {
        let selected = jobTableView.indexPathForSelectedRow
        jobTableView.reloadData()
        jobTableView.selectRow(at: selected, animated: false, scrollPosition: .none)
    }

    func getData() {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            jobs = try managedContext.fetch(Jobtitle.fetchRequest())
        } catch {
            print("Fetching jobtitles failed")
        }
    }
    
    func save(name: String) {
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let job = Jobtitle(context: managedContext)
        job.name = name
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func openJobs() -> [Worktime] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let sortByStart = NSSortDescriptor(key: "start", ascending: false)
        let searchByOngoing = NSPredicate(format: "end == nil")
        let requestForBatch: NSFetchRequest<Worktime> = Worktime.fetchRequest()
        
        requestForBatch.predicate = searchByOngoing
        requestForBatch.sortDescriptors = [sortByStart]
        var results: [Worktime] = []
        
        do {
            results = try context.fetch(requestForBatch)
        } catch {
            print("fetch failed")
        }
        return results
    }
    
    // NSTIMER SETUP!!!
    //
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    func setCellTimeLabel(start: Date) -> String {
        let elapsed:TimeInterval = Date().timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        let elapsedInt = NSInteger(elapsed)
        let hours = elapsedInt/3600
        let minutes = (elapsedInt/60)%60
        let seconds = elapsedInt % 60
        return String(format: "%.02d: %0.2d: %0.2d", hours, minutes, seconds)
    }
    func updateTimer() {
        if (timerForWork != nil) {
            reloadTable()
        } else {
            timer.invalidate()
        }
    }
    
    func timerDidChange() {
        let openjobs = openJobs()
        if openjobs.isEmpty {
            timer.invalidate()
            timerForWork = nil
        } else {
            timerForWork = openjobs.first
            if !timer.isValid { setTimer() }
        }
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
        if segue.identifier == "worktimeListForJob" {
            let controller = segue.destination as! WorktimeListViewController
            controller.job = jobs[(sender as! IndexPath).row]
        }
    }

}
