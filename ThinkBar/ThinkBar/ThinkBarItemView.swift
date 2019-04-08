//
//  ThinkBar.swift
//  ThinkBar
//
//  Created by Dev on 4/7/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import Foundation
import UIKit

class ThinkBarItemView: UIView {
    let item: ThinkBarItem
    let titleLabel = UILabel()
    let iconView = UIImageView()
    
    public var selected = false
    
    override var tintColor: UIColor! {
        didSet {
            if self.selected {
                self.iconView.tintColor = self.tintColor
            }
            self.titleLabel.textColor = self.tintColor
        }
    }
    private let defaultFont = UIFont.systemFont(ofSize: 12)
    var font: UIFont? {
        didSet {
            self.titleLabel.font = self.font ?? defaultFont
        }
    }
    
    init(_ item: ThinkBarItem) {
        self.item = item
        super.init(frame: CGRect.zero)
        
        if let customView = self.item.customView {
            assert(self.item.title == nil && self.item.icon == nil, "Don't set title / icon when using a custom view")
            assert(customView.frame.width > 0 && customView.frame.height > 0, "Custom view must have a width & height > 0")
            self.addSubview(customView)
        } else {
            assert(self.item.title != nil && self.item.icon != nil, "Title / Icon not set")
            if let title = self.item.title {
                titleLabel.text = title
                titleLabel.font = self.defaultFont
                titleLabel.textColor = self.tintColor
                titleLabel.textAlignment = .center
                titleLabel.alpha = 0.0
                self.addSubview(titleLabel)
            }
            
            if let icon = self.item.icon {
                iconView.image = icon.withRenderingMode(.alwaysTemplate)
                iconView.contentMode = .scaleAspectFit
                self.addSubview(iconView)
            }
        }
        tintColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let customView = self.item.customView {
            customView.center = CGPoint(x: self.frame.width / 2 + self.item.offset.horizontal,
                                        y: self.frame.height / 2 + self.item.offset.vertical)
        } else {
            titleLabel.frame = CGRect(x: 0, y: self.frame.height, width: self.frame.width, height: 14)
            iconView.frame = CGRect(x: self.frame.width / 2 - 13, y: 12, width: 26, height: 20)
        }
        
    }
    
    
    
    func setSelected(_ selected: Bool, animated: Bool = true) {
        self.selected = selected
        self.iconView.tintColor = selected ? self.tintColor : UIColor(white: 0.6, alpha: 1.0)
        
        if (animated && selected) {
            UIView.animate(withDuration: 0.2) {
                self.titleLabel.frame.origin.y = 28
                self.titleLabel.alpha = 1.0
                self.iconView.frame.origin.y = 5
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.titleLabel.frame.origin.y = self.frame.size.height
                self.titleLabel.alpha = 0.0
                self.iconView.frame.origin.y = 12
            }
        }
    }
}

