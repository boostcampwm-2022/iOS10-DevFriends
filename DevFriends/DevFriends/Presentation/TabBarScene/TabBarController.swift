//
//  TabBarController.swift
//  DevFriends
//
//  Created by 심주미 on 2022/11/23.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let tabBarViewModel: TabBarViewModel
    
    init(tabBarViewModel: TabBarViewModel) {
        self.tabBarViewModel = tabBarViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarViewModel.showChat()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
