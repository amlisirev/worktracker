//
//  reportsComposer.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 13/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class ReportsComposer: NSObject {

    let pathToHourlistTemplate = Bundle.main.path(forResource: "hourlist", ofType: "html")
    let pathToRowitemTemplate = Bundle.main.path(forResource: "row_item", ofType: "html")
    var pageCount: NSInteger!
    var itemsPerPage: NSInteger!
    var fileURL: URL!
    var filename: String = ""
    
    override init() {
        super.init()
        pageCount = 0
        itemsPerPage = 20
    }
    
    init(itemsPerPage: NSInteger!) {
        super.init()
        pageCount = 0
        self.itemsPerPage = itemsPerPage
    }
    
    func renderHourlist(school: String, schoolclass: String, teachername: String, worktimes: [Worktime]) -> [String] {
        let pages: [[Worktime]] = stride(from: 0, to: worktimes.count, by: itemsPerPage).map {
            let end = worktimes.endIndex
            let pageEnd = worktimes.index($0, offsetBy: itemsPerPage, limitedBy: end) ?? end
            return Array(worktimes[$0..<pageEnd])
        }
        
        var stringPages: [String] = []
        for page in pages {
            stringPages.append(renderHourlistPage(school: school, schoolclass: schoolclass, teachername: teachername, worktimes: page))
        }
        pageCount = stringPages.count
        return stringPages
        
    }
    
    func renderHourlistPage(school: String, schoolclass: String, teachername: String, worktimes: [Worktime]) -> String! {
        do {
            var generatedHTML = try String(contentsOfFile: pathToHourlistTemplate!, encoding: String.Encoding.utf8)
            var totalDur: TimeInterval = 0.00
            generatedHTML = generatedHTML.replacingOccurrences(of: "#EMPTY_SIG#", with: " ")
            generatedHTML = generatedHTML.replacingOccurrences(of: "#CLASS#", with: " ")
            generatedHTML = generatedHTML.replacingOccurrences(of: "#SCHOOL#", with: school)
            generatedHTML = generatedHTML.replacingOccurrences(of: "#WORKER_NAME#", with: teachername)
            var allRows = ""
            for item in worktimes {
                var rowHTML: String!
                let timestring = timestringFromDate(item.start! as Date) + "-" + timestringFromDate(item.end! as Date)
                rowHTML = try String(contentsOfFile: pathToRowitemTemplate!, encoding: String.Encoding.utf8)
                rowHTML = rowHTML.replacingOccurrences(of: "#DATE#", with: datestringFromDate(item.start! as Date))
                rowHTML = rowHTML.replacingOccurrences(of: "#TIMES#", with: timestring)
                rowHTML = rowHTML.replacingOccurrences(of: "#HOURS#", with: hoursFromInterval(item.duration()))
                rowHTML = rowHTML.replacingOccurrences(of: "#EMPTY_SIG#", with: " ")
                rowHTML = rowHTML.replacingOccurrences(of: "#DESCRIPTION#", with: item.job!.name!)
                
                allRows += rowHTML
                totalDur.add(item.duration())
            }
            generatedHTML = generatedHTML.replacingOccurrences(of: "#ROWS#", with: allRows)
            generatedHTML = generatedHTML.replacingOccurrences(of: "#TOTALHOURS#", with: hoursFromInterval(totalDur))
            
            return generatedHTML
        } catch {
            print("couldn't open HTML template")
        }
        return nil
    }
    
    func hoursFromInterval(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        return formatter.string(from: interval)!
    }
    
    func datestringFromDate(_ setdate: Date) -> String {
        let dateformat = DateFormatter()
        dateformat.locale = Locale.current
        dateformat.dateStyle = .short
        dateformat.timeStyle = .none
        return dateformat.string(from: setdate)
    }
    
    func timestringFromDate(_ setdate: Date) -> String {
        let dateformat = DateFormatter()
        dateformat.locale = Locale.current
        dateformat.dateStyle = .none
        dateformat.timeStyle = .short
        return dateformat.string(from: setdate)
    }
    
    func renderHTMLStringPagesToPDF(_ HTMLContent: [String], filename: String) {
        let pageRenderer = A4PageRenderer()
        for (index, page) in HTMLContent.enumerated() {
            let printFormatter = UIMarkupTextPrintFormatter(markupText: page)
            pageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: index)
        }
        print("pages after pagerenderer loop", pageRenderer.numberOfPages)
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        for index in 0..<pageRenderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            pageRenderer.drawPage(at: index, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        
        self.filename = filename
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        fileURL = URL(fileURLWithPath: (filename + ".pdf"), isDirectory: false, relativeTo: documentsURL.first)
        pdfData.write(to: fileURL, atomically: true)
        print("saved " + fileURL.description)
    }
    
}
