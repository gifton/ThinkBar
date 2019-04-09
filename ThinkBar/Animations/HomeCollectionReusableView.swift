//
//  HomeCollectionReusableView.swift
//  ThinkBar
//
//  Created by Dev on 4/8/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit

class HomeHeader: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public static var identifier: String {
        return "HomeHeader"
    }
}


class HomeCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public static var identifier: String {
        return "HomeCell"
    }
}
