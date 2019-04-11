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
    
    let photos: [UIImage] = [#imageLiteral(resourceName: "02"), #imageLiteral(resourceName: "01"), #imageLiteral(resourceName: "12"), #imageLiteral(resourceName: "03"), #imageLiteral(resourceName: "04"), #imageLiteral(resourceName: "08-1"), #imageLiteral(resourceName: "05"), #imageLiteral(resourceName: "10"), #imageLiteral(resourceName: "12"), #imageLiteral(resourceName: "04"), #imageLiteral(resourceName: "09"), #imageLiteral(resourceName: "11")]
    
    
    func setCV() {
        let homeCV: UICollectionView = {
            let cvLayout = HomeLayout()
            cvLayout.delegate = self
            let cv = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: cvLayout)
            cv.backgroundColor = .white
            
            return cv
        }()
        addSubview(homeCV)
        homeCV.register(HomeCell.self, forCellWithReuseIdentifier: HomeCell.identifier)
        homeCV.register(HomeHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HomeHeader.identifier)
        homeCV.delegate = self
        homeCV.dataSource = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var currentPos: CGFloat = 0.0
}

extension HomeView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
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
        
        let position = scrollView.contentOffset.y
        let progress = position / (UIScreen.main.bounds.height * 0.72)
        
        print(self.currentPos, position)
    }
}

extension HomeView: HomeLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        
        return photos[indexPath.item].size.height
    }
}
