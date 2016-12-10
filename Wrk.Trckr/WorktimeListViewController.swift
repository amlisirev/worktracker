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
        worktimeTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        // title = "Hours for " + job.name as! String
        // WHY WONT THIS WORK!
        // worktimes = job.worktimes as! [Worktime]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sortBy = NSSortDescriptor(key: "start", ascending: false)
        let searchBy = NSPredicate(format: "job == %@", job)
        let request: NSFetchRequest<Worktime> = Worktime.fetchRequest()
        request.predicate = searchBy
        request.sortDescriptors = [sortBy]
        do {
            worktimes = try context.fetch(request)
        } catch {
            print("fetch failed")
        }

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
        let cell = worktimeTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let starttime = worktimes[indexPath.row].start as! Date
        let dateformat = DateFormatter()
        dateformat.locale = Locale.current
        dateformat.dateStyle = .long
        dateformat.timeStyle = .medium
        cell.textLabel?.text = dateformat.string(from: starttime)
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
