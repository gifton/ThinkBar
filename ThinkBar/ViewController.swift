//
//  ViewController.swift
//  ThinkBar
//
//  Created by Dev on 4/7/19.
//  Copyright © 2019 Wesaturate. All rights reserved.
//

import UIKit




class HomeBar: UIViewController, ThinkBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        view = HomeView(frame: .zero)
        createSimpleTabBar()
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
