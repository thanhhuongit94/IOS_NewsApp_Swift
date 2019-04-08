//
//  Tbl_Menu.swift
//  News_App
//
//  Created by huongnguyen on 19/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
import UIKit

class Tbl_Menu: NSObject{
    //MARK: Properties
    var menuID :String = String()
    var menuContent: String = String()
    var menuPhoto : UIImage?
    
    override init(){}
    init?(menuID : String, menuContent: String, menuPhoto: UIImage?) {
        if menuID.isEmpty || menuContent.isEmpty {
            return nil
        }
        self.menuID = menuID
        self.menuContent = menuContent
        self.menuPhoto = menuPhoto
    }
}
