//
//  JobTitleCell.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 04/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class JobTitleCell: UITableViewCell {

    @IBOutlet weak var jobtitle: UILabel!
    @IBOutlet weak var jobcount: UILabel!
    @IBOutlet weak var jobtimer: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTimerLabel(start: Date) {
        let elapsed:TimeInterval = Date().timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        let elapsedInt = NSInteger(elapsed)
        let hours = elapsedInt/3600
        let minutes = (elapsedInt/60)%60
        let seconds = elapsedInt % 60
        jobtimer.text = String(format: "%.02d: %0.2d: %0.2d", hours, minutes, seconds)
    }

}
