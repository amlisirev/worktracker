//
//  PreviewViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 13/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    var reportsComposer: ReportsComposer!
    var HTMLContent: String!
    var worktimes: [Worktime] = []
    
    @IBOutlet weak var webPreview: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createReportAsHTML()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createReportAsHTML() {
        reportsComposer = ReportsComposer()
        let reportHTML = reportsComposer.renderHourlist(school: "lumo", schoolclass: " ", teachername: "Sakari", worktimes: worktimes).first
        webPreview.loadHTMLString(reportHTML!, baseURL: URL(string: reportsComposer.pathToHourlistTemplate!))
        HTMLContent = reportHTML
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
