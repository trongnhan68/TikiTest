//
//  KeywordItem.swift
//  HotKeyword
//
//  Created by Jacky Nguyen on 3/30/19.
//  Copyright © 2019 Nhan NLT. All rights reserved.
//

import UIKit

struct Constants {
    static let kCellSpacing: Double = 16.0
    static let kIconSize: Double = 100.0
    static let kPaddingInCell: Double = 8.0
}

class KeywordItem {
    var itemSize: CGSize?
    var iconFrame: CGRect?
    var keywordFrame: CGRect?
    var numberOfLines: Int?
    var imageCached = UIImage(named: "Placeholder")
    
    var state = PhotoRecordState.new
    
    var keywordModel: KeywordModel
    
    init(keywordModel: KeywordModel) {
        self.keywordModel = keywordModel
    }
    
    func calculateItem() {
        let kw =  self.keywordModel.keyword
        let components = kw.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }
        let label: UILabel = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        if (words.count == 1) {
            label.text = kw
        } else {
            var fistLineText = ""
            for i in kw.count/2 - 1 ... kw.count {
                var char = kw[i]
                if char == " " {
                    char = "\n"
                    fistLineText = kw.substring(toIndex: i)
                    break
                }
            }
            label.text = fistLineText
        }
        label.sizeToFit()
        
        let firstLineWidth = label.bounds.size.width
        let labelWidth = Double(firstLineWidth) + Double(Constants.kPaddingInCell * 2)
        let labelHeight:Double = Double(label.font.lineHeight * 2) + Double(Constants.kPaddingInCell * 2)
        
        self.iconFrame = CGRect(x: (Double(labelWidth) - Constants.kIconSize)/2, y: 0, width: Constants.kIconSize, height: Constants.kIconSize)
        self.keywordFrame = CGRect(x: 0, y: Constants.kIconSize + Constants.kPaddingInCell, width: Double(labelWidth), height: labelHeight)
        
        self.itemSize = CGSize(width: labelWidth, height: Constants.kIconSize + Constants.kPaddingInCell + labelHeight)
    }
}

