//
//  ViewController.swift
//  ThinkBar
//
//  Created by Dev on 4/7/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit

class HomeBar: UIViewController, ThinkBarDelegate {
    func tabSelected(_ index: Int) {
        print(index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSimpleTabBar()
    }
    
    private func createSimpleTabBar() {
        var items = [ThinkBarItem]()
        items.append(ThinkBarItem(title: "Home", icon: #imageLiteral(resourceName: "HomeButton")))
        items.append(ThinkBarItem(title: "Profile", icon: #imageLiteral(resourceName: "person")))
        items.append(ThinkBarItem(title: "Tickets", icon: #imageLiteral(resourceName: "tickets")))
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
}
