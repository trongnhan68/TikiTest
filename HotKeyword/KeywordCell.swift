//
//  KeywordCell.swift
//  HotKeyword
//
//  Created by Nhan NLT on 3/29/19.
//  Copyright © 2019 Nhan NLT. All rights reserved.
//

import UIKit

class KeywordCell: UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.keywordLabel.isHidden = false
        self.iconImageView.isHidden = false
    }
    var keywordItem: KeywordItem?
    
    lazy var iconImageView: UIImageView = {
        let imageView : UIImageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        
        self.contentView.addSubview(imageView)
        return imageView
    }()
    lazy var keywordLabel: UILabel = {
        let keywordLabel : UILabel = UILabel()
        keywordLabel.font = UIFont.systemFont(ofSize: 14)
        keywordLabel.textAlignment = .center
        keywordLabel.lineBreakMode = .byWordWrapping
        keywordLabel.textColor = UIColor.white
        keywordLabel.layer.cornerRadius = 10
        keywordLabel.layer.masksToBounds = true
        keywordLabel.numberOfLines = 2
        self.contentView.addSubview(keywordLabel)
        
        return keywordLabel
    }()
    
    func setObject(obj: KeywordItem) {
        keywordItem = obj
        if keywordItem != nil {
            self.iconImageView.image = keywordItem?.imageCached
            self.keywordLabel.text = keywordItem?.keywordModel.keyword
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layout()
    }
    
    func layout() {
        if keywordItem != nil {
            self.iconImageView.frame = keywordItem?.iconFrame ?? CGRect.zero
            self.keywordLabel.frame = keywordItem?.keywordFrame ?? CGRect.zero
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconImageView.image = nil
        
    }
    
}
