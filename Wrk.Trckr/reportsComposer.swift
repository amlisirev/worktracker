//
//  reportsComposer.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 13/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class reportsComposer: NSObject {

    let pathToHourlistTemplate = Bundle.main.path(forResource: "hourlist", ofType: "html")
    let pathToRowitemTemplate = Bundle.main.path(forResource: "row_item", ofType: "html")
    var pdfFilename: String!
    
    override init() {
        super.init()
    }
    
    func renderHourlist(school: String, schoolclass: String, teachername: String, worktimes: [Worktime]) -> String! {
        do {
            var generatedHTML = try String(contentsOfFile: pathToHourlistTemplate!, encoding: String.Encoding.utf8)
            var totalDur: TimeInterval!
            generatedHTML = generatedHTML.replacingOccurrences(of: "#EMPTY_SIG#", with: " ")
            generatedHTML = generatedHTML.replacingOccurrences(of: "#SCHOOL#", with: school)
            generatedHTML = generatedHTML.replacingOccurrences(of: "#WORKER_NAME#", with: teachername)
            var allRows = ""
            for item in worktimes {
                var rowHTML: String!
                rowHTML = try String(contentsOfFile: pathToRowitemTemplate!, encoding: String.Encoding.utf8)
                rowHTML = rowHTML.replacingOccurrences(of: "#DATE#", with: item.start!.description)
                rowHTML = rowHTML.replacingOccurrences(of: "#HOURS#", with: item.duration().description)
                rowHTML = rowHTML.replacingOccurrences(of: "#EMPTY_SIG#", with: " ")
                rowHTML = rowHTML.replacingOccurrences(of: "#JOB_DESCR#", with: item.job!.name!)
                
                allRows += rowHTML
                totalDur.add(item.duration())
            }
            generatedHTML = generatedHTML.replacingOccurrences(of: "#ROWS#", with: allRows)
            let total = totalDur.description
            generatedHTML = generatedHTML.replacingOccurrences(of: "#TOTAL_HOURS#", with: total)
            
            return generatedHTML
        } catch {
            print("couldn't open HTML template")
        }
        return nil
    }
    
}
