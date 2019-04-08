//
//  ThinkBar.swift
//  ThinkBar
//
//  Created by Dev on 4/7/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import Foundation
import UIKit

public class ThinkBar: UIView {
    
    public weak var delegate: ThinkBarDelegate?
    public let keyLine = UIView()
    public override var tintColor: UIColor! {
        didSet {
            for itv in self.itemViews {
                itv.tintColor = self.tintColor
            }
        }
    }
    public var font: UIFont? {
        didSet {
            for itv in self.itemViews {
                itv.font = self.font
            }
        }
    }
    
    private let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular)) as UIVisualEffectView
    public var backgroundBlurEnabled: Bool = true {
        didSet {
            self.visualEffectView.isHidden = !self.backgroundBlurEnabled
        }
    }
    
    fileprivate var itemViews = [ThinkBarItemView]()
    fileprivate var currentSelectedIndex: Int?
    fileprivate let bg = UIView()
    
    public init(items: [ThinkBarItem]) {
        super.init(frame: CGRect.zero)
        
        
        bg.backgroundColor = .lightGray
        addSubview(bg)
        
//        self.addSubview(visualEffectView)
        
        keyLine.backgroundColor = .lightGray
        self.addSubview(keyLine)
        
        var i = 0
        for item in items {
            let itemView = ThinkBarItemView(item)
            itemView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ThinkBar.itemTapped(_:))))
            self.itemViews.append(itemView)
            self.addSubview(itemView)
            i += 1
        }
        
        self.selectItem(0, animated: false)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        bg.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1000)
        visualEffectView.frame = bg.bounds
        keyLine.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1)
        
        let itemWidth = self.frame.width / CGFloat(self.itemViews.count)
        for (i, itemView) in self.itemViews.enumerated() {
            let x = itemWidth * CGFloat(i)
            itemView.frame = CGRect(x: x, y: 0, width: itemWidth, height: frame.size.height)
        }
    }
    
    @objc func itemTapped(_ gesture: UITapGestureRecognizer) {
        let itemView = gesture.view as! ThinkBarItemView
        let selectedIndex = self.itemViews.firstIndex(of: itemView)!
        self.selectItem(selectedIndex)
    }
    
    public func selectItem(_ selectedIndex: Int, animated: Bool = true) {
        if !self.itemViews[selectedIndex].item.selectable {
            return
        }
        if (selectedIndex == self.currentSelectedIndex) {
            return
        }
        self.currentSelectedIndex = selectedIndex
        
        for (index, v) in self.itemViews.enumerated() {
            let selected = (index == selectedIndex)
            v.setSelected(selected, animated: animated)
        }
        
        for item in itemViews {
            if item.selected == true {
                item.frame.size.width += 100
            } else {
                item.frame.size.width -= 33
            }
        }
        self.delegate?.tabSelected(selectedIndex)
    }
}
