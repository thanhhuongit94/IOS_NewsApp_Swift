//
//  TabMain_Controller.swift
//  News_App
//
//  Created by huongnguyen on 22/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import UIKit

class TabMain_Controller: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //self.selectedViewController = self.viewControllers?[1]
        // Do any additional setup after loading the view.
       // UITabBar.appearance().tintColor = UIColor.blue
    }
    override func viewWillAppear(_ animated: Bool) {
         self.selectedViewController = self.viewControllers?[1]
        
    }
}
