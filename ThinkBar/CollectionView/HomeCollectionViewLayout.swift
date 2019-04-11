//
//  HomeCollectionViewLayout.swift
//  ThinkBar
//
//  Created by Dev on 4/9/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit

protocol HomeLayoutDelegate: class {
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class HomeLayout: UICollectionViewLayout {
    
    weak var delegate: HomeLayoutDelegate!
    
    fileprivate var numberOfColumns = 2
    fileprivate var cellPadding: CGFloat = 6
    
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    fileprivate var contentHeight: CGFloat = 0
    
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    // header variables
    private var orderChangeProgress: CGFloat?
    private var lastCellZIndex: Int = 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    public var headerMaxHeight: CGFloat = round(UIScreen.main.bounds.height * 0.486)  {
        didSet { resetStoredValues() }
    }
    public var headerMinHeight: CGFloat = 197 {
        didSet { resetStoredValues() }
    }
    private var animationProgress: CGFloat {
        let offset = collectionView?.contentOffset.y ?? 0
        let normalizedOffset = max(0.0, min(1.0, offset/animationScrollLength))
        return normalizedOffset
    }
    private var defaultCellZIndex: Int = 5
    public var animationScrollLength: CGFloat = 150.0  {
        didSet {
            orderChangeProgress  = nil
            lastCellZIndex = defaultCellZIndex
        }
    }
    
    override func prepare() {
        // 1
        guard cache.isEmpty == true, let collectionView = collectionView else {
            return
        }
        // 2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        
        // 3
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            // 4
            let photoHeight = delegate.collectionView(collectionView, heightForPhotoAtIndexPath: indexPath)
            let height = cellPadding * 2 + photoHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    
}

// MARK: all funcs for header
extension HomeLayout {
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
       var output: [UICollectionViewLayoutAttributes] = []
        
        let stndrd = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
        if let headerAttr = headerAttributes() {
            output.append(headerAttr)
        }
        
        return output
    }
    
    private func headerAttributes() -> UICollectionViewLayoutAttributes? {
        guard headerSize(forProgress: animationProgress) > 0 else {
            return nil
        }
        let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))
//        let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionReusableView, with: IndexPath(item: 0, section: 0))
        headerAttr.zIndex = 2
        headerAttr.frame = CGRect(x: contentOffset.width, y: contentOffset.height, width: width, height: headerSize(forProgress: animationProgress))
        return headerAttr
        return nil
    }
    
    private func headerSize(forProgress progress: CGFloat) -> CGFloat {
        guard headerMaxHeight > 0 else {
            return 0
        }
        let offset = collectionView?.contentOffset.y ?? 0
        if offset <= 0 {
            return headerMaxHeight - offset * 2
        }
        return headerMaxHeight - (headerMaxHeight - headerMinHeight) * progress
    }
    
    private func resetStoredValues() {
        print("Restored values()")
    }
}

