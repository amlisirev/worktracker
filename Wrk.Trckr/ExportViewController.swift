//
//  ExportViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 06/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ExportViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var worktimeTableView: UITableView!
    // can't be weak or they wont get set in the segue!
    var startDate: NSDate!
    var endDate: NSDate!
    var jobs: [Jobtitle] = []
    var work: [Worktime] = []
    
    // variables necessary for pdfcomposer
    var composer: ReportsComposer!
    
    @IBAction func Export(_ sender: AnyObject) {
        let filenameAlert = UIAlertController(title: "Export as PDF", message: "choose filename", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
           guard let textField = filenameAlert.textFields?.first,
            let filename = textField.text else {
                return
            }
        self.exportPDF(filename)
        self.showEmailAlert()
        }
        
        filenameAlert.addTextField { (textField: UITextField) -> Void in}
        filenameAlert.addAction(cancelAction)
        filenameAlert.addAction(saveAction)
        present(filenameAlert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("you got this far, export!!!", jobs.count)
        worktimeTableView.register(UINib(nibName: "WorktimeCell", bundle: nil), forCellReuseIdentifier: "WorktimeCell")
        getData()
        worktimeTableView.reloadData()
        print(startDate.description + " jeejee DATE " + endDate.description)

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
    
    // EXPORT FUNCTION
    //
    
    func exportPDF(_ file: String!) {
        composer = ReportsComposer()
        let defaults = UserDefaults.standard
        let workplace = defaults.string(forKey: "workplace") ?? "workplace_placeholder"
        let fullname = defaults.string(forKey: "fullname") ?? "fullname_placeholder"
        let reportHTML = composer.renderHourlist(school: workplace, schoolclass: " ", teachername: fullname, worktimes: work)
        composer.renderHTMLStringPagesToPDF(reportHTML, filename: file)
    }
    
    // send mail if possible!
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setSubject("your latest work report")
            mail.setMessageBody("The latest report of my work hours", isHTML: false)
            mail.addAttachmentData(NSData(contentsOf: composer.fileURL)! as Data, mimeType: "application/pdf", fileName: composer.filename)
            present(mail, animated:true, completion: nil)
        }
    }
    // custom popup alerts!
    
    func showEmailAlert() {
        let alert = UIAlertController(title: "PDF created successfully", message: "Would you like to send it to someone?", preferredStyle: .alert)
        let mailAction = UIAlertAction(title: "Send", style: .default) { [unowned self] action in
            DispatchQueue.main.async {
                self.sendMail()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) {(action: UIAlertAction) -> Void in}
        
        alert.addAction(cancelAction)
        alert.addAction(mailAction)
        present(alert, animated: true, completion: nil)
    }
    
    // COREDATA
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        work = Worktime.worktimesForJobAndDates(context, jobs: jobs, startDate: startDate, endDate: endDate)
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
        
        if segue.identifier == "exportPreview" {
            let controller = segue.destination as! PreviewViewController
            controller.worktimes = work
        }
    }

}
