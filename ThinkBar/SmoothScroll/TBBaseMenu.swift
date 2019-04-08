//
//  TBBaseMenu.swift
//  ThinkBar
//
//  Created by Dev on 4/8/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit

class TBBaseMenu: UICollectionReusableView, TBAnimatable {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    func configure() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.0
    }
    
    func update(toAnimationProgress progress: CGFloat) {
        layer.cornerRadius = 14 * progress
        layer.shadowOpacity = Float(progress * 0.5)
    }
}

