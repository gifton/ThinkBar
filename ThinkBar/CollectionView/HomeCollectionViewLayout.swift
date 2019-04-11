//
//  HomeCollectionViewLayout.swift
//  ThinkBar
//
//  Created by Dev on 4/9/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit

@objc protocol HomeLayoutDelegate: class {
    @objc func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
    @objc optional func collectionView(_ collectionView: UICollectionView, didUpdateAnimationTo progress: CGFloat)
    @objc optional func collectionView(_ collectionView: UICollectionView, titleSizeForProgress progress: CGFloat) -> CGSize
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
    
    public var spacing: CGFloat = 1.0  {
        didSet { resetStoredValues() }
    }
    public var headerMaxHeight: CGFloat = round(UIScreen.main.bounds.height * 0.486)  {
        didSet { resetStoredValues() }
    }
    public var headerMinHeight: CGFloat = 100 {
        didSet { resetStoredValues() }
    }
    public var cellsMaxMargin: CGFloat = 18.0 {
        didSet { resetStoredValues() }
    }
    private var itemSize: CGFloat {
        return (width - spacing - cellsMargin * 2)/2.0
    }
    private var cellsMargin: CGFloat {
        return cellsMaxMargin * (1 - animationProgress)
    } 
    private var defaultCellZIndex: Int = 5
    public var animationScrollLength: CGFloat = 150.0  {
        didSet {
            orderChangeProgress  = nil
            lastCellZIndex = defaultCellZIndex
        }
    }
    private var width: CGFloat = 0
    private var numberOfItems = 0
    private var animationProgress: CGFloat {
        let offset = collectionView?.contentOffset.y ?? 0
        let normalizedOffset = max(0.0, min(1.0, offset/animationScrollLength))
        return normalizedOffset
    }
    
    // Prepare collumns layout
    override func prepare() {
        register(HomeHeader.self, forDecorationViewOfKind: UICollectionView.elementKindSectionHeader)
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
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
//    public override var collectionViewContentSize: CGSize {
//        let itemsHeight = CGFloat(ceil(Double(numberOfItems)/2.0)) * itemSize
//        let offset = collectionView?.contentOffset.y ?? 0
//        if offset <= 0 {
//            return CGSize(width: width, height: ceil(headerMaxHeight + menuMaxHeight + menuToCellsStartOffset + itemsHeight))
//        }
//        return CGSize(width: width, height: ceil(itemsHeight + cellOffset(forProgress: animationProgress)))
//    }
}

// MARK: all funcs for header
extension HomeLayout {
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       var result: [UICollectionViewLayoutAttributes] = []
        
        if let headerAttr = headerAttributes() {
            result.append(headerAttr)
        }
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                result.append(attributes)
            }
        }
        return result
    }
    
    private func headerAttributes() -> UICollectionViewLayoutAttributes? {
        guard headerSize(forProgress: animationProgress) > 0 else {
            return nil
        }
        let headerAttr = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: IndexPath(item: 0, section: 0))

        headerAttr.zIndex = 2
        headerAttr.frame = CGRect(x: (collectionView?.contentOffset.x)!, y: (collectionView?.contentOffset.y)!, width: (collectionView?.frame.width)!, height: headerSize(forProgress: animationProgress))
        return headerAttr
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
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

