//
//  HomeView.swift
//  ThinkBar
//
//  Created by Dev on 4/8/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import Foundation
import UIKit

class HomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        setCV()
    }
    
    let homeCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width - 30, height: 200)
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 160)
        let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .white
        
        return cv
    }()
    
    
    func setCV() {
        addSubview(homeCV)
        homeCV.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        homeCV.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeader.identifier)
        homeCV.delegate = self
        homeCV.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.identifier, for: indexPath) as! HomeCell
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeader.identifier, for: indexPath) as! HomeHeader
        print("added header!")
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var startColor: UIColor = #colorLiteral(red: 0.8941176471, green: 0.8, blue: 0.7607843137, alpha: 1)
        var finishColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        
        func update(toAnimationProgress progress: CGFloat) {
            header.textColor = UIColor(red: startColor.rgba.red + (finishColor.rgba.red - startColor.rgba.red) * progress,
                                         green: startColor.rgba.green + (finishColor.rgba.green - startColor.rgba.green) * progress,
                                         blue: startColor.rgba.blue + (finishColor.rgba.blue - startColor.rgba.blue) * progress,
                                         alpha: startColor.rgba.alpha + (finishColor.rgba.alpha - startColor.rgba.alpha) * progress)
        }
    }
}
