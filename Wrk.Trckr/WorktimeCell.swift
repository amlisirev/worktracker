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
    
    func setHoursFromInterval(_ interval: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        hours.text = formatter.string(from: interval)
    }
    
    func setDatestringFromDate(_ setdate: Date) {
        let dateformat = DateFormatter()
        dateformat.locale = Locale.current
        dateformat.dateStyle = .short
        dateformat.timeStyle = .short
        
        date.text = dateformat.string(from: setdate)
    }
    
}
