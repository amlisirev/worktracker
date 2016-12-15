//
//  SettingsViewController.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 11/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var workplace: UITextField!
    
    @IBAction func saveAction(_ sender: AnyObject) {
        let defaults = UserDefaults.standard
        defaults.set(fullname.text!, forKey: "fullname")
        defaults.set(workplace.text!, forKey: "workplace")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        fullname.text = defaults.string(forKey: "fullname")
        workplace.text = defaults.string(forKey: "workplace")

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

}
