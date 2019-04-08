//
//  Tbl_Permission.swift
//  News_App
//
//  Created by huongnguyen on 27/11/2018.
//  Copyright © 2018 huongnguyen. All rights reserved.
//

import Foundation
class Tbl_Permission{
    //MARK: Properties
    var Username : String = String()
    var MenuIDPermiss : String = String()
    var Permiss : String = String()
    
    //Contructor
    init(){}
    init? (username: String, menuID: String, permiss: String){
        if username.isEmpty || menuID.isEmpty || permiss.isEmpty {
            return nil
        }
        self.Username = username
        self.MenuIDPermiss = menuID
        self.Permiss = permiss
    }
}
