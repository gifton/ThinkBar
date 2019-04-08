//
//  ViewController.swift
//  ThinkBar
//
//  Created by Dev on 4/7/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit

class TestCell: TBBaseGridCell {
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
}

class HeaderBlock: TBBaseHeader {
    @IBOutlet weak var csTextBottom: NSLayoutConstraint!
    @IBOutlet weak var csImageTop: NSLayoutConstraint!
    
    override func update(toAnimationProgress progress: CGFloat) {
        super.update(toAnimationProgress: progress)
        csTextBottom.constant = 44 + 200 * progress
        csImageTop.constant = -400 * progress * 1.5
        UIView.animate(withDuration: 0.01) {
            self.layoutIfNeeded()
        }
    }
}


class ManuBlock: TBBaseMenu {
    
    override func update(toAnimationProgress progress: CGFloat) {
        super.update(toAnimationProgress: progress)
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
}


class HomeBar: UIViewController, ThinkBarDelegate {

    let cv: UICollectionView = {
        let layout = TBSmoothScrollLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return cv
    }()
    
    let viewAnimator = TBViewAnimator()
    var titleSize: CGSize = .zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        createSimpleTabBar()
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(cv)
        
        cv.register(UINib(nibName: "Header", bundle: nil),
                                forSupplementaryViewOfKind: TBSmoothScrollLayout.kCBAnimatedLayoutHeader,
                                withReuseIdentifier: TBSmoothScrollLayout.kCBAnimatedLayoutHeader)
        cv.register(UINib(nibName: "Menu", bundle: nil),
                                forSupplementaryViewOfKind: TBSmoothScrollLayout.kCBAnimatedLayoutMenu,
                                withReuseIdentifier: TBSmoothScrollLayout.kCBAnimatedLayoutMenu)
        cv.register(UINib(nibName: "Title", bundle: nil),
                                forSupplementaryViewOfKind: TBSmoothScrollLayout.kCBAnimatedLayoutTitle,
                                withReuseIdentifier: TBSmoothScrollLayout.kCBAnimatedLayoutTitle)
        if let title = UINib(nibName: "Title", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView {
            title.sizeToFit()
            titleSize = title.frame.size
        }
        
    }
    
    private func createSimpleTabBar() {
        var items = [ThinkBarItem]()
        items.append(ThinkBarItem(title: "Home", icon: #imageLiteral(resourceName: "home")))
        items.append(ThinkBarItem(title: "Search", icon: #imageLiteral(resourceName: "Search")))
        items.append(ThinkBarItem(title: "Profile", icon: #imageLiteral(resourceName: "user-astronaut")))
        items.append(ThinkBarItem(title: "THiNK", icon: #imageLiteral(resourceName: "cloud")))
        let tabBar = ThinkBar(items: items)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.delegate = self
        self.view.addSubview(tabBar)
        
        let constraints = [
            tabBar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tabBar.widthAnchor.constraint(equalTo: view.widthAnchor),
            tabBar.heightAnchor.constraint(equalToConstant: 44),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func tabSelected(_ index: Int) {
        print("Selected tab: ", index)
    }
}


extension HomeBar: UICollectionViewSmoothScrollLayoutDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let supplementaryView: UICollectionReusableView
        switch kind {
        case TBSmoothScrollLayout.kCBAnimatedLayoutHeader,
             TBSmoothScrollLayout.kCBAnimatedLayoutMenu,
             TBSmoothScrollLayout.kCBAnimatedLayoutTitle:
            supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kind, for: indexPath)
        default:
            fatalError("unexpected element type")
        }
        if let animatableView = supplementaryView as? TBAnimatable {
            viewAnimator.register(animatableView: animatableView)
        }
        return supplementaryView
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    var startDate: Date {
        return dateFormatter.date(from: "11:00") ?? Date()
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "test", for: indexPath)
        if let cell = cell as? TestCell {
            cell.lblTime.text = dateFormatter.string(from: startDate.addingTimeInterval(TimeInterval(60*30*indexPath.item)))
            viewAnimator.register(animatableView: cell)
            cell.lblPrice.text = "$\(Int.random(in: 1...12) * 10)"
        }
        return cell
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didUpdateAnimationTo progress: CGFloat) {
        viewAnimator.updateAnimation(toProgress: progress)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, titleSizeForProgress progress: CGFloat) -> CGSize {
        return titleSize
    }
    
}
