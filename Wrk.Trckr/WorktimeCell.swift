//
//  WorktimeCell.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 10/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class WorktimeCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var jobtitle: UILabel!
    @IBOutlet weak var hours: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setHoursFromDates(_ start: Date, end: Date) {
        let elapsed = end.timeIntervalSinceReferenceDate - start.timeIntervalSinceReferenceDate
        let elapsedInt = NSInteger(elapsed)
        let sethours = elapsedInt / 3600
        let setminutes = (elapsedInt/60)%60
        hours.text = String(format: "%0.2d hrs %0.2d min", sethours, setminutes)
    }
    
    func setDatestringFromDate(_ setdate: Date) {
        let dateformat = DateFormatter()
        dateformat.locale = Locale.current
        dateformat.dateStyle = .short
        dateformat.timeStyle = .short
        
        date.text = dateformat.string(from: setdate)
    }
    
}
