//
//  KeywordModel.swift
//  HotKeyword
//
//  Created by Nhan NLT on 3/29/19.
//  Copyright © 2019 Nhan NLT. All rights reserved.
//

import UIKit

struct KeywordModel: Codable {
    var icon: String
    var keyword: String
    
    init(icon: String, keyword: String?) {
        self.icon = icon
        self.keyword = keyword ?? ""
    }
}

struct Keyword:Codable {
    var keywords: Array<KeywordModel>
}

