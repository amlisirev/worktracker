//
//  PdfPageRenderer.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 14/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import UIKit

class A4PageRenderer: UIPrintPageRenderer {

    let A4PageWidth: CGFloat = 595.2
    let A4PageHeight: CGFloat = 841.8
    
    
    override init() {
        super.init()
        let pageFrame = CGRect(x: 0, y: 0, width: A4PageWidth, height: A4PageHeight)
        let printFrame = pageFrame.insetBy(dx: 10, dy: 10)
        self.setValue(NSValue(cgRect: pageFrame), forKey: "paperRect")
        self.setValue(NSValue(cgRect:printFrame), forKey: "printableRect")
    }
}
